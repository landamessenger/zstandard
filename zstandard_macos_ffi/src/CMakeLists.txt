# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_macos_ffi_library VERSION 0.0.1 LANGUAGES C)

# Encuentra los archivos C de Zstd
file(GLOB ZSTD_SRC
        "zstd/common/*.c"
        "zstd/compress/*.c"
        "zstd/decompress/*.c"
)

# Agrega el ejecutable para el plugin
add_library(zstandard_macos_ffi SHARED
        # "Classes/plugin_code.cpp"
        ${ZSTD_SRC}
)

add_library(zstandard_macos_ffi SHARED
  "zstandard_macos_ffi.c"
)

target_include_directories(zstandard_macos_ffi PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}/zstd"
    "${CMAKE_CURRENT_SOURCE_DIR}/zstd/common"
    "${CMAKE_CURRENT_SOURCE_DIR}/zstd/compress"
    "${CMAKE_CURRENT_SOURCE_DIR}/zstd/decompress"
)

set_target_properties(zstandard_macos_ffi PROPERTIES
  PUBLIC_HEADER zstandard_macos_ffi.h
  OUTPUT_NAME "zstandard_macos_ffi"
)

target_compile_definitions(zstandard_macos_ffi PUBLIC DART_SHARED_LIB)
