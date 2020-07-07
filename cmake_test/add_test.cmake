include_guard()
include(cmake_test/detail_/add_test)
include(cmake_test/overrides)
include(cmake_test/colors)

function(dump_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            if (NOT MATCHED)
                continue()
            endif()
        endif()
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()

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

    string(RANDOM ALPHABET "abcdefghijklmnopqrstuvwxyz" "${CT_ADD_TEST_NAME}") #Randomized identifier, only alphabetical characters so it generates a valid identifier.
    get_property(curr_tests GLOBAL PROPERTY "CMAKE_TEST_TESTS")

    list(APPEND curr_tests "${${CT_ADD_TEST_NAME}}") #Add the test ID to the list of tests being executed
    set_property(GLOBAL PROPERTY "CMAKE_TEST_TESTS" "${curr_tests}") #Update the global list of tests

    get_property(tests GLOBAL PROPERTY "CMAKE_TEST_TESTS")
    set_property(GLOBAL PROPERTY "CMAKE_TEST_${${CT_ADD_TEST_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}") #Mark the test as expecting to fail or not
    set_property(GLOBAL PROPERTY "CMAKE_TEST_${${CT_ADD_TEST_NAME}}_FRIENDLY_NAME" "${CT_ADD_TEST_NAME}") #Store the friendly name for the test
endmacro()

#[[[
# Adds a test section, should be called inside of a declared test function directly before declaring the section function.
# The NAME parameter will be populated as by set() with the generated section function name. Declare the section function using this generated name. Ex:
#
# .. code-block:: cmake
#
#    #This is inside of a declared test function
#    ct_add_section(NAME this_section)
#    function(${this_section})
#        message(STATUS "This code will run in a test section")
#    endfunction()
#
# :param EXPECTFAIL: Option indicating whether the section is expected to fail or not, if specified will cause the section to be ran in a subprocess.
# :param NAME name: Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.
#]]
macro(ct_add_section)

    #TODO Set sections as a subproperty of CT_CURRENT_EXECUTION_UNIT instead of as a single global variable
    set(options EXPECTFAIL)
    set(oneValueArgs NAME)
    set(multiValueArgs "")
    cmake_parse_arguments(CT_ADD_SECTION "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    string(RANDOM ALPHABET "abcdefghijklmnopqrstuvwxyz" "${CT_ADD_SECTION_NAME}") #Generate random section ID, using only alphabetical characters
    get_property(curr_exec_unit GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
    get_property(curr_sections GLOBAL PROPERTY "CMAKE_TEST_${curr_exec_unit}_SECTIONS")
    list(APPEND curr_sections "${${CT_ADD_SECTION_NAME}}")
    set_property(GLOBAL PROPERTY CMAKE_TEST_${curr_exec_unit}_SECTIONS "${curr_sections}") #Append the section ID to the list of sections, since this will be executed in the test's scope we need to set it in parent_scope
    #message(STATUS "Adding section: ${CT_ADD_SECTION_NAME}")
    set_property(GLOBAL PROPERTY "CMAKE_TEST_${curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_EXPECTFAIL" "${CT_ADD_SECTION_EXPECTFAIL}") #Set a flag for whether the section is expected to fail or not
    set_property(GLOBAL PROPERTY "CMAKE_TEST_${curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_FRIENDLY_NAME" "${CT_ADD_SECTION_NAME}") #Store the friendly name for the test

endmacro()


#[[[
# Execute all declared tests in a file. This function will be ran after ``include()``ing the test file.
# It will execute a subprocess for all declared tests that are expected to fail, but run all other tests in-process.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#]]
function(ct_exec_tests)
    #[[
    #set(options EXPECTFAIL)
    #set(oneValueArgs NAME)
    #set(multiValueArgs "")
    #cmake_parse_arguments(CT_EXEC_TEST "${options}" "${oneValueArgs}"
    #                      "${multiValueArgs}" ${ARGN} )
    #]]



    message(STATUS "Executing tests")

    set(CMAKE_TESTS_DID_PASS "TRUE" PARENT_SCOPE) #Default to true and set to false once one does not pass

    # Add general exception handler that catches all exceptions
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)

        get_property(curr_exec GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
        get_property(curr_exceptions GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS")

        list(APPEND curr_exceptions "Type: ${exce_type}, Details: ${message}")
        set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS" "${curr_exceptions}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTION_DETAILS" "Type: ${exce_type}, Details: ${message}")
    endfunction()

    get_property(tests GLOBAL PROPERTY "CMAKE_TEST_TESTS")

    foreach(curr_test ${tests})
        #Set the fully qualified identifier for this test, used later for exception tracking and section/subsection execution
        set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${curr_test}")
        get_property(friendly_name GLOBAL PROPERTY "CMAKE_TEST_${curr_test}_FRIENDLY_NAME")
        message(STATUS "Running test named \"${friendly_name}\"")

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake" "${curr_test}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake")
        ct_exec_sections()
        get_property(ct_exceptions GLOBAL PROPERTY "${curr_test}_EXCEPTION")
        #get_property(ct_exception_details GLOBAL PROPERTY "${curr_test}_EXCEPTION_DETAILS")
        if("${CMAKE_TEST_${curr_test}_EXPECTFAIL}")
            if(NOT "${ct_exceptions}")
                message("Test named \"${friendly_name}\" was expected to fail but did not throw any exceptions or errors.")
                set(CMAKE_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
            endif()
        else()
            if(NOT ("${ct_exceptions}" STREQUAL ""))
                #file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake" "${curr_test}()")
                #include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake")
                #ct_exec_sections()
                foreach(exc ${ct_exceptions})
                    message("${BoldRed}Test named \"${friendly_name}\" raised exception:")
                    message("${exc}${ColorReset}")
                endforeach()
                set(CMAKE_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
            endif()
        endif()
        #ct_exec_sections(${curr_test})
    endforeach()
endfunction()

#[[[
# Execute sections of a test. This will be called directly after running the enclosing test,
# and will execute sections in a subprocess if they are expected to fail.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#]]
function(ct_exec_sections)
    #Get the identifier for the current execution unit (test/section/subsection)
    get_property(ct_original_unit GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
    get_property(unit_sections GLOBAL PROPERTY "CMAKE_TEST_${ct_original_unit}_SECTIONS")
    foreach(curr_section "${unit_sections}")


        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${ct_original_unit}_${curr_section}")
        get_property(friendly_name GLOBAL PROPERTY "CMAKE_TEST_${ct_original_unit}_${curr_section}_FRIENDLY_NAME")

        message(STATUS "Executing section named \"${friendly_name}\"")


        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${curr_section}.cmake" "${curr_section}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/sections/${curr_section}.cmake")
        get_property(ct_exceptions GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTIONS")
        #get_property(ct_exception_details GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTION_DETAILS")
        get_property(expect_fail GLOBAL PROPERTY "CMAKE_TEST_${ct_original_unit}_${curr_section}_EXPECTFAIL")
        if("${expect_fail}")
            if("${ct_exceptions}" STREQUAL "")
                message("Section named \"${friendly_name}\" was expected to fail but did not throw any exceptions or errors.")
            endif()

        else()
            if(NOT "${ct_exceptions}" STREQUAL "")
                foreach(exc ${ct_exceptions})
                    message("${BoldRed}Section named \"${friendly_name}\" raised exception:")
                    message("${exc}${ColorReset}")
                endforeach()
           endif()
       endif()
    endforeach()
    set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${ct_original_unit}")


endfunction()
