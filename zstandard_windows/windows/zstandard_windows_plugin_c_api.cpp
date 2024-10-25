#include "include/zstandard_windows/zstandard_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "zstandard_windows_plugin.h"

void ZstandardWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  zstandard_windows::ZstandardWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
