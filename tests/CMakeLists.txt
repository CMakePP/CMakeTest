cmake_minimum_required(VERSION 3.14) #Required for FetchContent_MakeAvailable()

project(CMakeTest LANGUAGES C) #Need C language so CMake doesn't complain about no linker language for some empty files used for tests
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
cmake_policy(SET CMP0002 OLD) #Allow duplicate targets by overriding, needed for multiple tests that work with the same target

#Enable colors in Unix environments, ignored on Windows. Will not work with pipes
set(CMAKETEST_USE_COLORS "True")

include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/../cmake/get_cpp.cmake")

function(add_cmake_test_test)
    foreach(testi ${ARGN})
        include(${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
    endforeach()
endfunction()

add_subdirectory(asserts)
#add_subdirectory(detail_)
#add_subdirectory(tutorials)
ct_exec_tests()
cpp_get_global(did_tests_pass "CMAKETEST_TESTS_DID_PASS")

if(NOT did_tests_pass)
    ct_exit("Testing of CMakeTest failed")
endif()
