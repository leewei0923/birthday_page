import 'birthday_page_platform_interface.dart';

export 'src/birthday_celebration_page.dart';

class BirthdayPage {
  Future<String?> getPlatformVersion() {
    return BirthdayPagePlatform.instance.getPlatformVersion();
  }
}
