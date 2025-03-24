package `in`.abhishak.better_dynamic_icon

import android.content.ComponentName
import android.content.Context
import android.content.pm.ActivityInfo
import android.content.pm.PackageManager
import android.content.pm.PackageManager.ComponentEnabledSetting
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class AppIconManager(val applicationContext: Context, val result:Result, val call:MethodCall) {

    private fun getPackageNameAndPackageManager() : Pair<String, PackageManager> {
        return applicationContext.getPackageName() to applicationContext.getPackageManager()
    }

    private fun getActivities() : Array<ActivityInfo>{

        val (packageName,packageManager) = getPackageNameAndPackageManager();
        // Query all activities and aliases
        val activityAndAliasesName : Array<ActivityInfo> = packageManager.getPackageInfo(
            packageName,
            PackageManager.GET_ACTIVITIES or PackageManager.MATCH_DISABLED_COMPONENTS
        ).activities?: emptyArray()

        return activityAndAliasesName;
    }

    fun getAllIcons(): List<Map<String, Any?>> {
        val (packageName,packageManager) = getPackageNameAndPackageManager();
        val activities : Array<ActivityInfo> = getActivities();
        val icons = mutableListOf<Map<String, Any?>>()
        for (activityInfo in activities ) {
            val componentName = ComponentName(packageName, activityInfo.name)
            var isEnabled = false

            val enabledComponentSetting = packageManager.getComponentEnabledSetting(componentName)

            if(enabledComponentSetting == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT){
                isEnabled = activityInfo.isEnabled()
            }else{
                isEnabled = enabledComponentSetting != PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            }

            val icon = activityInfo.loadIcon(packageManager)

            icons.add(mapOf(
                "name" to activityInfo.name,
                "label" to activityInfo.loadLabel(packageManager).toString(),
                "enabled" to isEnabled,
                "icon" to drawableToBitmap(icon) // Convert Drawable to Bitmap
            ))
        }

        return icons
    }

    private fun drawableToBitmap(drawable: Drawable): ByteArray? {
        // Convert Drawable to Bitmap and then to ByteArray
        if (drawable is BitmapDrawable) {
            val bitmap = drawable.bitmap
            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            return stream.toByteArray()
        }
        return null
    }

    fun changeIcon() {
        val (packageName,packageManager) = getPackageNameAndPackageManager()
        ///Get List of Activities with Aliases of that activity
        val activityAndAliasesName : Array<ActivityInfo> = getActivities()

        ///Get list of disabled Activities
        val disabledActivities = activityAndAliasesName.filter {
            val componentName = ComponentName(applicationContext.packageName, it.name)
            packageManager.getComponentEnabledSetting(componentName) ==
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED
        }

        val enabledActivity = activityAndAliasesName.find{
            val componentName = ComponentName(applicationContext.packageName, it.name)
            packageManager.getComponentEnabledSetting(componentName) ==
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED ||  packageManager.getComponentEnabledSetting(componentName) ==
                    PackageManager.COMPONENT_ENABLED_STATE_DEFAULT
        }

        //Name of enabledActivity
        val enabledActivityName = enabledActivity?.name ?: "NA";

        val activityToEnable = (call.arguments as Map<String,String>)["iconName"] ?: "NA";

        if(enabledActivityName == activityToEnable){
            result.success("Already Present")
        }
        else{
            try{
                val updates = listOf(
                    ComponentEnabledSetting(
                        ComponentName(applicationContext, enabledActivity?.name ?: "KNA"),
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                        PackageManager.DONT_KILL_APP),
                    ComponentEnabledSetting(
                        ComponentName(applicationContext, activityToEnable),
                        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                        PackageManager.DONT_KILL_APP),
                )
                packageManager.setComponentEnabledSettings(updates)
                result.success("Done")
            }catch (e: Exception){
                result.error("Not Found" , e.message, null)
            }
        }
    }
}