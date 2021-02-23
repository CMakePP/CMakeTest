#cmake_minimum_required(VERSION 3.10) #Use include_guard()
#project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)

#option(BUILD_TESTING "Should we build and run the unit tests?" OFF)


#function(message)
#	_message("Message called")
#endfunction()


list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
include(cmake_test/cmake_test)
#set(CMAKE_TEST_TESTS a b)
ct_add_test(NAME test_this)
function(${test_this})
	#include(FindPython)
    #file(STRINGS /proc/self/status _cmake_process_status)

    # Grab the PID of the parent process
    #string(REGEX MATCH "PPid:[ \t]*([0-9]*)" _ ${_cmake_process_status})

    # Grab the absolute path of the parent process
    #file(READ_SYMLINK /proc/${CMAKE_MATCH_1}/exe _cmake_parent_process_path)

    # Compute CMake arguments only if CMake was not invoked by the native build
    # system, to avoid dropping user specified options on re-triggers.
    #if(NOT ${_cmake_parent_process_path} STREQUAL ${CMAKE_MAKE_PROGRAM})
    #    execute_process(COMMAND bash -c "tr '\\0' ' ' < /proc/$PPID/cmdline"
    #                    OUTPUT_VARIABLE _cmake_args)

    #    string(STRIP "${_cmake_args}" _cmake_args)

    #    set(CMAKE_ARGS "${_cmake_args}"
    #        CACHE STRING "CMake command line args (set by end user)" FORCE)
    #endif()
    #message(STATUS "User Specified CMake Arguments: ${CMAKE_ARGS}")

    #ct_add_section(NAME test_section PARENTTEST ${test_this} EXPECTFAIL)
    ct_add_section(NAME test_section EXPECTFAIL)
    function(${test_section})
        message(FATAL_ERROR "Running section")
        cpp_raise(ASSERT_FAIL "Assertion failed")
        ct_add_section(NAME section_2)
        function(${section_2})
           # message("Section 2")
        endfunction()

    endfunction(${test_section})

    ct_add_section(NAME section_3)
    function(${section_3})
        #Don't do anything here
    endfunction()


endfunction()


#RANDOMSTRING()

#ct_end_test(test_this)

#message("${test_this}")
#message("${CMAKE_TEST_TESTS}")

#if("${BUILD_TESTING}")
#    include(CTest)
#    add_subdirectory(tests)
#endif()
