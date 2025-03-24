part of 'implementation.dart';

abstract class BetterDynamicIconPlatform extends PlatformInterface {
  /// Constructs a BetterDynamicIconPlatform.
  BetterDynamicIconPlatform() : super(token: _token);

  static final Object _token = Object();

  static BetterDynamicIconPlatform _instance = MethodChannelBetterDynamicIcon();

  /// The default instance of [BetterDynamicIconPlatform] to use.
  ///
  /// Defaults to [MethodChannelBetterDynamicIcon].
  static BetterDynamicIconPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BetterDynamicIconPlatform] when
  /// they register themselves.
  static set instance(BetterDynamicIconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> changeAppIcon(String iconName) {
    throw UnimplementedError('changeAppIcon() has not been implemented.');
  }

  Future<List<IconDetails>> getAllIcons() {
    throw UnimplementedError('getAllIcons() has not been implemented.');
  }
}
