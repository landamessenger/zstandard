# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_android_library VERSION 0.0.1 LANGUAGES C)

add_definitions(-DZSTD_ENABLE_ASM_X86_64_BMI2=0)

add_definitions(-DDYNAMIC_BMI2=0)

# Encuentra los archivos C de Zstd
file(GLOB ZSTD_SRC
        "common/*.c"
        "compress/*.c"
        "decompress/*.c"
)

# Agrega el ejecutable para el plugin
add_library(zstandard_android SHARED
        # "Classes/plugin_code.cpp"
        ${ZSTD_SRC}
)

target_include_directories(zstandard_android PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/common"
    "${CMAKE_CURRENT_SOURCE_DIR}/compress"
    "${CMAKE_CURRENT_SOURCE_DIR}/decompress"
)

set_target_properties(zstandard_android PROPERTIES
  PUBLIC_HEADER zstandard_android.h
  OUTPUT_NAME "zstandard_android"
)

target_compile_definitions(zstandard_android PUBLIC DART_SHARED_LIB)
