cmake_minimum_required(VERSION 3.10) #Use include_guard()
project(CMakeTest VERSION 1.0.0)

option(BUILD_TESTING "Should we build and run the unit tests?" OFF)
if("${BUILD_TESTING}")
    include(CTest)
    add_subdirectory(tests)
endif()
