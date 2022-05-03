include_guard()


#[[[
# Defines the exception handler and registers it with CMakePP.
#
# The exception handler stores exception information about the currently
# running test, then re-executes ``ct_exec_tests()`` so that all tests are ran.
# Once all tests are ran, all exceptions are looped over and printed
# before the interpreter is forceably shutdown.
#
#]]
function(ct_register_exception_handler)
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)
        cpp_get_global(_ae_curr_exec_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
        CTExecutionUnit(GET "${_ae_curr_exec_instance}" _ae_curr_exec_friendly_name friendly_name)
        CTExecutionUnit(GET "${_ae_curr_exec_instance}" _ae_curr_exec_exceptions exceptions)
        list(APPEND _ae_curr_exec_exceptions "Type: ${exce_type}, Details: ${message}")
        CTExecutionUnit(SET "${_ae_curr_exec_instance}" exceptions "${_ae_curr_exec_exceptions}")
        CTExecutionUnit(GET "${_ae_curr_exec_instance}" _ae_friendly_name friendly_name)
        CTExecutionUnit(GET "${_ae_curr_exec_instance}" _as_parent_print_length print_length)

        cpp_append_global(CMAKETEST_FAILED_TESTS "${_ae_curr_exec_instance}")

	CTExecutionUnit(GET "${_ae_curr_exec_instance}" _ae_section_depth section_depth)

        _ct_print_fail("${_ae_friendly_name}" "${_ae_section_depth}" "${_ae_print_length}")

        CTExecutionUnit(SET "${_ae_curr_exec_instance}" has_printed TRUE)

        CTExecutionUnit(SET "${_ae_curr_exec_instance}" has_executed TRUE)
        ct_exec_tests()


        #All tests have been executed now
        cpp_get_global(_ae_failed_tests CMAKETEST_FAILED_TESTS)
        foreach(_ae_failed_test_instance IN LISTS _ae_failed_tests)
            CTExecutionUnit(GET "${_ae_failed_test_instance}" _ae_failed_test_name friendly_name)
            CTExecutionUnit(GET "${_ae_failed_test_instance}" _ae_failed_test_exceptions exceptions)
            set(_ae_failed_exception_messages "")
            foreach(_ae_exception_message IN LISTS _ae_failed_test_exceptions)
                set(_ae_failed_exception_messages "${_ae_failed_exception_messages}\n${_ae_exception_message}")
            endforeach()
            set(_ae_failure_message "${_ae_failure_message}\nUnexpected exceptions caught while executing test \"${_ae_curr_exec_friendly_name}\". ${_ae_failed_exception_messages}")
        endforeach()

        ct_exit("${_ae_failure_message}")

    endfunction()


endfunction()
