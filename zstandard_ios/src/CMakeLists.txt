# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(zstandard_ios_library VERSION 0.0.1 LANGUAGES C)

add_library(zstandard_ios SHARED
  "zstandard_ios.c"
)

set_target_properties(zstandard_ios PROPERTIES
  PUBLIC_HEADER zstandard_ios.h
  OUTPUT_NAME "zstandard_ios"
)

target_compile_definitions(zstandard_ios PUBLIC DART_SHARED_LIB)
