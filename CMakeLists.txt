set(_ct_min_cmake_version "3.14")
cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

#Enable colors in Unix environments, ignored on Windows. Will not work with pipes
set(CMAKETEST_USE_COLORS "True")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")
include(cmake_test/cmake_test)

if("${BUILD_TESTING}")
    message("Building tests")

    include(CTest)
    enable_testing()
    add_subdirectory("tests")

    #add_test(
    #    NAME
    #        CMakeTest
    #    COMMAND
    #        "${CMAKE_CTEST_COMMAND}"
    #            --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/tests"
    #                             "${CMAKE_CURRENT_BINARY_DIR}/tests"
    #            --build-generator "${CMAKE_GENERATOR}"
    #            --test-command "${CMAKE_CTEST_COMMAND}"
    #)
endif()


#Example on how to execute a test
#get_filename_component(CMAKETEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/examples/CMakeTest.cmake" ABSOLUTE)

#include("${CMAKETEST_CURRENT_FILE}")
#ct_exec_tests()
