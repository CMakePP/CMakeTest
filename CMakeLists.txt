cmake_minimum_required(VERSION 3.10) #Use include_guard()
project(CMakeTest VERSION 1.0.0)

option(BUILD_TESTS "Should we build and run the unit tests?" TRUE)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
