set(_ct_min_cmake_version "3.14")
cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
option(BUILD_DOCS "Whether documentation targets should be added" OFF)
include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")
include(cmake_test/cmake_test)

if("${BUILD_TESTING}")
    message("Building tests")

    include(CTest)
    add_subdirectory("tests")

endif()

if(BUILD_DOCS)
    include("${PROJECT_SOURCE_DIR}/cmake/get_cminx.cmake")
    include(cminx)

    ct_register_exception_handler() #Catch any exceptions while building docs

    cminx_gen_rst("${CMAKE_CURRENT_SOURCE_DIR}/cmake_test/" "${CMAKE_CURRENT_SOURCE_DIR}/docs/source/developer/")

    cminx_add_docs_target("${CMAKE_CURRENT_SOURCE_DIR}/docs" "${CMAKE_CURRENT_BINARY_DIR}/docs" html)
endif()

#----------------------------------#
# Example on how to execute a test #
#----------------------------------#

# get_filename_component(CMAKETEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/examples/CMakeTest.cmake" ABSOLUTE)
# include("${CMAKETEST_CURRENT_FILE}")
# ct_exec_tests()

