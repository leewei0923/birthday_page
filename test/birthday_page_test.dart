import 'package:flutter_test/flutter_test.dart';
import 'package:birthday_page/birthday_page.dart';
import 'package:birthday_page/birthday_page_platform_interface.dart';
import 'package:birthday_page/birthday_page_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBirthdayPagePlatform
    with MockPlatformInterfaceMixin
    implements BirthdayPagePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BirthdayPagePlatform initialPlatform = BirthdayPagePlatform.instance;

  test('$MethodChannelBirthdayPage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBirthdayPage>());
  });

  test('getPlatformVersion', () async {
    BirthdayPage birthdayPagePlugin = BirthdayPage();
    MockBirthdayPagePlatform fakePlatform = MockBirthdayPagePlatform();
    BirthdayPagePlatform.instance = fakePlatform;

    expect(await birthdayPagePlugin.getPlatformVersion(), '42');
  });
}
