cmake_minimum_required(VERSION 3.14) #Use include_guard()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)
set(CMAKE_TEST_USE_COLORS "True")

include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")
get_filename_component(CMAKE_TEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/examples/CMakeTest.cmake" ABSOLUTE)

include("${CMAKE_TEST_CURRENT_FILE}")
ct_exec_tests()
