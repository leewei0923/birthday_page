import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'birthday_page_platform_interface.dart';

/// An implementation of [BirthdayPagePlatform] that uses method channels.
class MethodChannelBirthdayPage extends BirthdayPagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('birthday_page');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
