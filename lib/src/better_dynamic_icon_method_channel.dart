part of 'implementation.dart';

/// An implementation of [BetterDynamicIconPlatform] that uses method channels.
class MethodChannelBetterDynamicIcon extends BetterDynamicIconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('better_dynamic_icon');

  @override
  Future<String?> changeAppIcon(String iconName) async {
    String? value = await methodChannel
        .invokeMethod<String?>('changeAppIcon', <String, String>{
      'iconName': iconName,
    });

    return value;
  }

  @override
  Future<List<IconDetails>> getAllIcons() async {
    try {
      final List<dynamic> icons =
          await methodChannel.invokeMethod('getAllIcons');
      // Convert List<dynamic> to List<Map<String, dynamic>>
      final List<IconDetails> values = [];

      for (var value in icons) {
        values.add(IconDetails.fromJson(value));
      }
      return values;
    } catch (e) {
      print("Failed to get icons: ${e}");
      return [];
    }
  }
}
