cmake_minimum_required(VERSION 3.10)

project(guitar-signal-processor VERSION 0.0.1 LANGUAGES CXX C ASM)

include(${CMAKE_CURRENT_SOURCE_DIR}/toolchain/arm-none-eabi-gcc.cmake)

add_subdirectory(vendor)
add_subdirectory(lib)
add_subdirectory(app)
