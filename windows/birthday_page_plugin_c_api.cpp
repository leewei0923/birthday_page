#include "include/birthday_page/birthday_page_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "birthday_page_plugin.h"

void BirthdayPagePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  birthday_page::BirthdayPagePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
