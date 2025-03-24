package `in`.abhishak.better_dynamic_icon

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.pm.PackageManager
import `in`.abhishak.better_dynamic_icon.AppIconManager
import android.content.Context
import android.content.pm.ActivityInfo
import android.content.ComponentName
import android.content.pm.PackageManager.ComponentEnabledSetting
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream

/** BetterDynamicIconPlugin */
class BetterDynamicIconPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext : Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "better_dynamic_icon")
    applicationContext = flutterPluginBinding.getApplicationContext()
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "changeAppIcon") {
      AppIconManager(applicationContext,result,call).changeIcon();
    }
    else if(call.method == "getAllIcons"){
      result.success(AppIconManager(applicationContext,result,call).getAllIcons());
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}