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
    #Default to true and set to false once one does not pass
    cpp_set_global(CMAKETEST_TESTS_DID_PASS "TRUE")

    # Add general exception handler that catches all exceptions
    ct_register_exception_handler()

    cpp_get_global(_et_instances "CMAKETEST_TEST_INSTANCES")

    foreach(_et_curr_instance IN LISTS _et_instances)
        #Execute test
        CTExecutionUnit(execute "${_et_curr_instance}")
    endforeach()
endfunction()
