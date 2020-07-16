include_guard()

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

    set(CMAKETEST_TESTS_DID_PASS "TRUE" PARENT_SCOPE) #Default to true and set to false once one does not pass

    # Add general exception handler that catches all exceptions
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)

        get_property(curr_exec GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
        get_property(curr_exceptions GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS")

        list(APPEND curr_exceptions "Type: ${exce_type}, Details: ${message}")
        set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS" "${curr_exceptions}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTION_DETAILS" "Type: ${exce_type}, Details: ${message}")
    endfunction()

    get_property(tests GLOBAL PROPERTY "CMAKETEST_TEST_TESTS")

    foreach(curr_test IN LISTS tests)
        #Set the fully qualified identifier for this test, used later for exception tracking and section/subsection execution
        set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${curr_test}")
        get_property(friendly_name GLOBAL PROPERTY "CMAKETEST_TEST_${curr_test}_FRIENDLY_NAME")
        get_property(expect_fail GLOBAL PROPERTY "CMAKETEST_TEST_${curr_test}_EXPECTFAIL")
        #message(STATUS "Running test named \"${friendly_name}\"")

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake" "${curr_test}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake")
        #ct_exec_sections()
        get_property(ct_exceptions GLOBAL PROPERTY "${curr_test}_EXCEPTION")
        #get_property(ct_exception_details GLOBAL PROPERTY "${curr_test}_EXCEPTION_DETAILS")
        if(expect_fail)
            if("${ct_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Test named \"${friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")
                set(CMAKETEST_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
                set(CMAKETEST_TEST_FAIL "TRUE")
            endif()
        else()
            if(NOT ("${ct_exceptions}" STREQUAL ""))
                #file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake" "${curr_test}()")
                #include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake")
                #ct_exec_sections()
                foreach(exc IN LISTS ct_exceptions)
                    message("${CT_BoldRed}Test named \"${friendly_name}\" raised exception:")
                    message("${exc}${CT_ColorReset}")
                endforeach()
                set(CMAKETEST_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
                set(CMAKETEST_TEST_FAIL "TRUE")
            endif()
        endif()

        if(CMAKETEST_TEST_FAIL)
            _ct_print_fail("${friendly_name}" 0)
        else()
            _ct_print_pass("${friendly_name}" 0)
        endif()
        ct_exec_sections()
    endforeach()
endfunction()
