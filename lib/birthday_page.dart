
import 'birthday_page_platform_interface.dart';

class BirthdayPage {
  Future<String?> getPlatformVersion() {
    return BirthdayPagePlatform.instance.getPlatformVersion();
  }
}
