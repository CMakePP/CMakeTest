cmake_minimum_required(VERSION 3.14) #Required for FetchContent_MakeAvailable()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

#Enable colors in Unix environments, ignored on Windows. Will not work with pipes
set(CMAKETEST_USE_COLORS "True")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")

#Example on how to execute a test
#get_filename_component(CMAKETEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/examples/CMakeTest.cmake" ABSOLUTE)

#include("${CMAKETEST_CURRENT_FILE}")
#ct_exec_tests()
