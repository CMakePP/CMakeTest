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

    #Default to true and set to false once one does not pass
    cpp_set_global(CMAKETEST_TESTS_DID_PASS "TRUE")

    # Add general exception handler that catches all exceptions
    ct_register_exception_handler()

    cpp_get_global(_et_instances "CMAKETEST_TEST_INSTANCES")


    foreach(_et_curr_instance IN LISTS _et_instances)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_curr_test_id test_id)


        #Set the fully qualified identifier for this test, used later for exception tracking and section/subsection execution
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${_et_curr_instance}")

        CTExecutionUnit(GET "${_et_curr_instance}" _et_friendly_name friendly_name)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_expect_fail expect_fail)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_print_length print_length)

        cpp_set_global("CMAKETEST_SECTION_DEPTH" 0)


        #Execute test
        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test_id}/${_et_curr_test_id}.cmake" "${_et_curr_test_id}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test_id}/${_et_curr_test_id}.cmake")

        CTExecutionUnit(GET "${_et_curr_instance}" _et_exceptions exceptions)

        if(_et_expect_fail)
            if("${_et_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Test named \"${_et_friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")

                #At least one test failed, so we will inform the caller that not all tests passed.
                cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE")
                set(_et_test_fail "TRUE")
            endif()
        else()
            if(NOT ("${_et_exceptions}" STREQUAL ""))

                foreach(_et_exc IN LISTS _et_exceptions)
                    message("${CT_BoldRed}Test named \"${_et_friendly_name}\" raised exception:")
                    message("${_et_exc}${CT_ColorReset}")
                endforeach()

                #At least one test failed, so we will inform the caller that not all tests passed.
                cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE")
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
        CTExecutionUnit(GET "${_et_curr_instance}" _et_section_map children)
        cpp_map(KEYS "${_et_section_map}" _et_has_sections)
	if(NOT _et_has_sections STREQUAL "")
            CTExecutionUnit(SET "${_et_curr_instance}" execute_sections TRUE)
            include("${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test_id}/${_et_curr_test_id}.cmake")
        endif()

    endforeach()
endfunction()
