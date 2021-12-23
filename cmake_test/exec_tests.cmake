include_guard()

#[[[
# Execute all declared tests in a file. This function will be ran after ``include()``ing the test file.
# This function will first write a file into the build directory containing a line calling the test function.
# This file will then be included, which causes said test function to be executed. All exceptions are tracked while the test is ran.
# Once the test has been executed, a flag will be set to execute the subsections, and the function executed once more.
# This will result in the subsections being executed, and their exceptions will also be tracked.
# Pass/fail output will be printed to the screen after each test or section has been executed, results are not aggregated at the end
# to prevent a faulty test from causing the interpeter to fail before results are printed.
#
# A test that is not expected to fail that raises an exception or a fatal error will result in the immediate termination of the interpreter
# due to unknown state and therefore leading to undefined behavior. To keep parity between different types of tests, EXPECTFAIL sections that do not raise
# exceptions will also halt all testing.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#
# .. seealso:: :func:`add_section.cmake.ct_add_section` for details on section execution.
#]]
function(ct_exec_tests)


    message(STATUS "Executing tests")

    cpp_set_global(CMAKETEST_TESTS_DID_PASS "TRUE") #Default to true and set to false once one does not pass

    # Add general exception handler that catches all exceptions
    ct_register_exception_handler()

    cpp_get_global(_et_tests "CMAKETEST_TESTS")

    foreach(_et_curr_test IN LISTS _et_tests)
        #Set the fully qualified identifier for this test, used later for exception tracking and section/subsection execution
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_et_curr_test}")
        cpp_get_global(_et_friendly_name "CMAKETEST_TEST_${_et_curr_test}_FRIENDLY_NAME")
        cpp_get_global(_et_expect_fail "CMAKETEST_TEST_${_et_curr_test}_EXPECTFAIL")
        cpp_get_global(_et_print_length "CMAKETEST_TEST_${_et_curr_test}_PRINT_LENGTH")

        cpp_set_global("CMAKETEST_SECTION_DEPTH" 0)



        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test}/${_et_curr_test}.cmake" "${_et_curr_test}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test}/${_et_curr_test}.cmake")
        cpp_get_global(_et_exceptions "${_et_curr_test}_EXCEPTIONS")

        if(_et_expect_fail)
            if("${_et_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Test named \"${_et_friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")
                cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
                set(_et_test_fail "TRUE")
            endif()
        else()
            if(NOT ("${_et_exceptions}" STREQUAL ""))

                foreach(_et_exc IN LISTS _et_exceptions)
                    message("${CT_BoldRed}Test named \"${_et_friendly_name}\" raised exception:")
                    message("${_et_exc}${CT_ColorReset}")
                endforeach()
                cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
                set(_et_test_fail "TRUE")
            endif()
        endif()

        if(_et_test_fail)
            _ct_print_fail("${_et_friendly_name}" 0 "${_et_print_length}")
            ct_exit()
        else()
            _ct_print_pass("${_et_friendly_name}" 0 "${_et_print_length}")
        endif()


        #Only execute second time if sections detected
        cpp_get_global(_et_has_sections "CMAKETEST_TEST_${_et_curr_test}_SECTIONS")
	if(NOT _et_has_sections STREQUAL "")
            cpp_set_global("CMAKETEST_TEST_${_et_curr_test}_EXECUTE_SECTIONS" TRUE)
            include("${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test}/${_et_curr_test}.cmake")
        endif()

    endforeach()
endfunction()
