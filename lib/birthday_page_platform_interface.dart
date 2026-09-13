import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'birthday_page_method_channel.dart';

abstract class BirthdayPagePlatform extends PlatformInterface {
  /// Constructs a BirthdayPagePlatform.
  BirthdayPagePlatform() : super(token: _token);

  static final Object _token = Object();

  static BirthdayPagePlatform _instance = MethodChannelBirthdayPage();

  /// The default instance of [BirthdayPagePlatform] to use.
  ///
  /// Defaults to [MethodChannelBirthdayPage].
  static BirthdayPagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BirthdayPagePlatform] when
  /// they register themselves.
  static set instance(BirthdayPagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
