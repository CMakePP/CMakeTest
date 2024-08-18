# 3.19 needed because of CMaize
set(_ct_min_cmake_version "3.19" CACHE INTERNAL "")
cmake_minimum_required(VERSION "${_ct_min_cmake_version}")
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    # Make sure projects using CMakeTest have this variable
    set(_ct_min_cmake_version "${_ct_min_cmake_version}" PARENT_SCOPE)
endif()

# Add cmake directory to CMake's module path, iff it's not already there
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" path_has_cmake)
if(${path_has_cmake} STREQUAL "-1")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)

# Fetch dependencies
include(get_cmakepp_lang)
include(get_cmaize)

# Make sure projects including CMakeTest can find it too
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()

include(cmake_test/cmake_test)

if("${BUILD_TESTING}")
    message("Building tests")

    include(CTest)
    add_subdirectory("tests/")
endif()
