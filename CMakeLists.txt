set(_ct_min_cmake_version "3.14" CACHE INTERNAL "")
cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	set(_ct_min_cmake_version "${_ct_min_cmake_version}" PARENT_SCOPE) #Make sure projects using CMakeTest have this variable
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE) #For projects including CMakeTest
endif()

include("${PROJECT_SOURCE_DIR}/cmake/get_cmaize.cmake")
include(cmake_test/cmake_test)

if("${BUILD_TESTING}")
    message("Building tests")

    include(CTest)
    add_subdirectory("tests")

endif()


#----------------------------------#
# Example on how to execute a test #
#----------------------------------#

# get_filename_component(CMAKETEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/examples/CMakeTest.cmake" ABSOLUTE)
# include("${CMAKETEST_CURRENT_FILE}")
# ct_exec_tests()

