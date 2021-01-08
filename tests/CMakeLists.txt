cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()

project(CMakeTest LANGUAGES C) #Need C language so CMake doesn't complain about no linker language for some empty files used for tests
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)


include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/../cmake/get_cpp.cmake")

ct_add_dir(".")
