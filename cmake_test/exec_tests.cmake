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



    #message(STATUS "Executing tests")

    #Default to true and set to false once one does not pass
    cpp_set_global(CMAKETEST_TESTS_DID_PASS "TRUE")

    # Add general exception handler that catches all exceptions
    ct_register_exception_handler()

    cpp_get_global(_et_instances "CMAKETEST_TEST_INSTANCES")


    foreach(_et_curr_instance IN LISTS _et_instances)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_curr_test_id test_id)

        #TODO Remove once all logic is within class
        CTExecutionUnit(GET "${_et_curr_instance}" _et_curr_instance_executed has_executed)
        if (_et_curr_instance_executed)
            continue()
        endif()
        #Test has not yet been executed


        CTExecutionUnit(GET "${_et_curr_instance}" _et_friendly_name friendly_name)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_expect_fail expect_fail)
        CTExecutionUnit(GET "${_et_curr_instance}" _et_print_length print_length)


        #Execute test
        CTExecutionUnit(execute "${_et_curr_instance}")
        CTExecutionUnit(print_pass_or_fail "${_et_curr_instance}")


        #Only execute second time if sections detected
        CTExecutionUnit(GET "${_et_curr_instance}" _et_section_map children)
        cpp_map(KEYS "${_et_section_map}" _et_has_sections)
	if(NOT _et_has_sections STREQUAL "")
            CTExecutionUnit(exec_sections "${_et_curr_instance}")
        endif()

        #All execution has completed
        CTExecutionUnit(SET "${_et_curr_instance}" has_executed TRUE)

    endforeach()
endfunction()
