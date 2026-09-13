#ifndef FLUTTER_PLUGIN_BIRTHDAY_PAGE_PLUGIN_H_
#define FLUTTER_PLUGIN_BIRTHDAY_PAGE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace birthday_page {

class BirthdayPagePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  BirthdayPagePlugin();

  virtual ~BirthdayPagePlugin();

  // Disallow copy and assign.
  BirthdayPagePlugin(const BirthdayPagePlugin&) = delete;
  BirthdayPagePlugin& operator=(const BirthdayPagePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace birthday_page

#endif  // FLUTTER_PLUGIN_BIRTHDAY_PAGE_PLUGIN_H_
