# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_windows_library VERSION 0.0.1 LANGUAGES C)

# Encuentra los archivos C de Zstd
file(GLOB ZSTD_SRC
        "*.c"
        "common/*.c"
        "compress/*.c"
        "decompress/*.c"
)

# Agrega el ejecutable para el plugin
add_library(zstandard_windows SHARED
        ${ZSTD_SRC}
)

target_include_directories(zstandard_windows PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/common"
    "${CMAKE_CURRENT_SOURCE_DIR}/compress"
    "${CMAKE_CURRENT_SOURCE_DIR}/decompress"
)

set_target_properties(zstandard_windows PROPERTIES
  PUBLIC_HEADER zstandard_windows.h
  OUTPUT_NAME "zstandard_windows"
)

target_compile_definitions(zstandard_windows PUBLIC DART_SHARED_LIB)
