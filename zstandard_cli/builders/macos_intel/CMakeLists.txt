# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_macos_library VERSION 0.0.1 LANGUAGES C)

# Encuentra los archivos C de Zstd
file(GLOB ZSTD_SRC
        "../../src/common/*.c"
        "../../src/compress/*.c"
        "../../src/decompress/*.c"
)

# Agrega el ejecutable para el plugin
add_library(zstandard_macos SHARED
        # "Classes/plugin_code.cpp"
        ${ZSTD_SRC}
)

target_include_directories(zstandard_macos PUBLIC
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/common"
    "${CMAKE_CURRENT_SOURCE_DIR}/compress"
    "${CMAKE_CURRENT_SOURCE_DIR}/decompress"
)

set_target_properties(zstandard_macos PROPERTIES
  PUBLIC_HEADER zstandard_macos.h
  OUTPUT_NAME "zstandard_macos"
)

target_compile_definitions(zstandard_macos PUBLIC
        DYNAMIC_BMI2=0
        HUF_NEED_BMI2_FUNCTION=0
        ZSTD_ENABLE_ASM_X86_64_BMI2=0
        DART_SHARED_LIB
)