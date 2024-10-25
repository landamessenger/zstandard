#ifndef FLUTTER_PLUGIN_ZSTANDARD_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_ZSTANDARD_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace zstandard_windows {

class ZstandardWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ZstandardWindowsPlugin();

  virtual ~ZstandardWindowsPlugin();

  // Disallow copy and assign.
  ZstandardWindowsPlugin(const ZstandardWindowsPlugin&) = delete;
  ZstandardWindowsPlugin& operator=(const ZstandardWindowsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace zstandard_windows

#endif  // FLUTTER_PLUGIN_ZSTANDARD_WINDOWS_PLUGIN_H_
