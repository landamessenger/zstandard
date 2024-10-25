# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_android_library VERSION 0.0.1 LANGUAGES C)

add_library(zstandard_android SHARED
  "zstandard_android.c"
)

set_target_properties(zstandard_android PROPERTIES
  PUBLIC_HEADER zstandard_android.h
  OUTPUT_NAME "zstandard_android"
)

target_compile_definitions(zstandard_android PUBLIC DART_SHARED_LIB)
