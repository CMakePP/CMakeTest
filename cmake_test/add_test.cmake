include_guard()
include(cmake_test/detail_/add_test)

#[[[ Defines a unit test for the CMakeTest framework.
#
# Unit testing in CMakeTest works by reflection. Namely, when the ``cmake``
# executable reads through the unit test the first unit testing command it must
# find is ``ct_add_test`` (finding any other command is an error). When it
# finds the first ``ct_add_test`` the file is read in and parsed. Based on the
# contents of the file ``CMakeLists.txt`` are generated, and then the tests are
# run. That all occurs in the function ``_ct_add_test_guts`` to avoid
# contaminating the testing namespace. Once all that is done we call
# ``return()`` from the ``ct_add_test`` macro, which since it is a macro returns
# from the unit test file without actually running any of the remaining
# commands.
#
# :param _at_test_name: The name of the unit test.
# :type _at_test_name: str
#]]
macro(ct_add_test)

    set(options EXPECTFAIL)
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(CT_ADD_TEST "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    set("${CT_ADD_TEST_NAME}" "RANDOMSTRING")
    list(APPEND CMAKE_TEST_TESTS "${${CT_ADD_TEST_NAME}}")
    set("CMAKE_TEST_${${CT_ADD_TEST_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}")
endmacro()


macro(ct_add_section)
    set(options EXPECTFAIL)
    set(oneValueArgs NAME PARENTTEST)
    set(multiValueArgs "")
    cmake_parse_arguments(CT_ADD_SECTION "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    set("${CT_ADD_SECTION_NAME}" "RANDOMSTRING_SECTION")
    set(CMAKE_TEST_SECTIONS "${${CT_ADD_SECTION_NAME}};${CMAKE_TEST_SECTIONS}") #Need set() because list() forces local scope, this macro is executed inside a test so we need parent scope to get to the test harness
    message("Adding section: ${CMAKE_TEST_SECTIONS}")
    set("CMAKE_TEST_${CT_ADD_SECTION_PARENTTEST}_${${CT_ADD_SECTION_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}")
endmacro()

macro(ct_exec_tests)
    #[[
    #set(options EXPECTFAIL)
    #set(oneValueArgs NAME)
    #set(multiValueArgs "")
    #cmake_parse_arguments(CT_EXEC_TEST "${options}" "${oneValueArgs}"
    #                      "${multiValueArgs}" ${ARGN} )
    #]]
    foreach(curr_test ${CMAKE_TEST_TESTS})
        if(CMAKE_TEST_${curr_test}_EXPECTFAIL)
            if(NOT CMAKE_TEST_EXECUTE)
                file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}")
                configure_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake_test/CMakeLists.txt.in" "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/CMakeLists.txt" @ONLY)
                ctest_configure(BUILD ${CMAKE_CURRENT_BINARY_DIR}/${curr_test} SOURCE ${CMAKE_CURRENT_BINARY_DIR}/${curr_test} CAPTURE_CMAKE_ERROR err)
            else()
                #This will be executed in the standard CMake interpreter as a child of CTest
                file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/test1.cmake" "${curr_test}()")
                include("${CMAKE_CURRENT_BINARY_DIR}/test1.cmake")
            endif()
        else()
            if(NOT CMAKE_TEST_EXECUTE)
                file(WRITE "test1.cmake" "${curr_test}()")
                include("test1.cmake")
            endif()
        endif()
        ct_exec_sections(${curr_test}) #We'll execute subsections in the current interpreter in case they need ctest commands
    endforeach()
endmacro()


macro(ct_exec_sections curr_test)
    message("Sections: ${CMAKE_TEST_SECTIONS}")
    foreach(curr_section ${CMAKE_TEST_SECTIONS})
        message(STATUS "Executing section: ${curr_section}")
        if(CMAKE_TEST_${curr_test}_${curr_section}_EXPECTFAIL)
            if(NOT CMAKE_TEST_EXECUTE)
                file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}")
                configure_file("cmake_test/CMakeLists.txt.in" "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}/CMakeLists.txt" @ONLY)
                ctest_configure(BUILD ${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section} SOURCE ${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section} CAPTURE_CMAKE_ERROR err)
            else()
                #This will be executed in the standard CMake interpreter as a child of CTest
                file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}/${curr_section}.cmake" "${curr_section}()")
                include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}/${curr_section}.cmake")
            endif()
        else()
            if(NOT CMAKE_TEST_EXECUTE)
                file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}/${curr_section}.cmake" "${curr_section}()")
                include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_section}/${curr_section}.cmake")
            endif()
        endif()

    endforeach()


endmacro()
