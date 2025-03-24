import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

part 'icon_details.dart';
part 'better_dynamic_icon_method_channel.dart';
part 'better_dynamic_icon_platform_interface.dart';

//Gives Access to the app icon change and fetch all icons
class BetterDynamicIcon {

  //For android provide full path of the activity name
  //For ios provide app icon name
  Future<String?> changeAppIcon(String iconName) {
    return BetterDynamicIconPlatform.instance.changeAppIcon(iconName);
  }

  //Android will fetch all the icons associated with activity and activity-aliases.
  //iOS will give us the list of imageassets along with the name.
  Future<List<IconDetails>> getAllIcons() {
    return BetterDynamicIconPlatform.instance.getAllIcons();
  }
}
