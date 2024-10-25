# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_ios_library VERSION 0.0.1 LANGUAGES C)

# Encuentra los archivos C de Zstd
file(GLOB ZSTD_SRC
        "common/*.c"
        "compress/*.c"
        "decompress/*.c"
)

# Agrega el ejecutable para el plugin
add_library(zstandard_ios SHARED
        # "Classes/plugin_code.cpp"
        ${ZSTD_SRC}
)

add_library(zstandard_ios SHARED
  "zstandard_ios.c"
)

target_include_directories(zstandard_ios PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/common"
    "${CMAKE_CURRENT_SOURCE_DIR}/compress"
    "${CMAKE_CURRENT_SOURCE_DIR}/decompress"
)

set_target_properties(zstandard_ios PROPERTIES
  PUBLIC_HEADER zstandard_ios.h
  OUTPUT_NAME "zstandard_ios"
)

target_compile_definitions(zstandard_ios PUBLIC DART_SHARED_LIB)
