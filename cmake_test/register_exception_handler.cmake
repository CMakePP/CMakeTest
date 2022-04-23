include_guard()


#[[[
# Defines the exception handler and registers it with CMakePP.
#
# The exception handler gather information from the globals about the currently running
# test and then outputs the information to the terminal before shutting down the interpreter.
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


        #cpp_get_global(_ae_friendly_name "CMAKETEST_TEST_${_ae_curr_exec}_FRIENDLY_NAME")
        cpp_get_global(_ae_section_depth "CMAKETEST_SECTION_DEPTH")
        #cpp_get_global(_as_parent_print_length "CMAKETEST_TEST_${_ae_curr_exec}_PRINT_LENGTH")

        _ct_print_fail("${_ae_friendly_name}" "${_ae_section_depth}" "${_ae_print_length}")

        CTExecutionUnit(SET "${_ae_curr_exec_instance}" has_printed TRUE)
        #message("Unexpected exception caught while executing test \"${_ae_curr_exec_friendly_name}\". Type: ${exce_type}, Details: ${message}")

        #cpp_append_global("CMAKETEST_TESTS_EXECUTED" "${_ae_curr_exec}")
        CTExecutionUnit(SET "${_ae_curr_exec_instance}" has_executed TRUE)
        ct_exec_tests()


        ct_exit("Unexpected exception caught while executing test \"${_ae_curr_exec_friendly_name}\". Type: ${exce_type}, Details: ${message}")

    endfunction()


endfunction()
