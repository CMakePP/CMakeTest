function(ct_register_exception_handler)
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)

        cpp_get_global(_ae_curr_exec "CT_CURRENT_EXECUTION_UNIT")
        cpp_get_global(_ae_curr_exec_friendly_name "CMAKETEST_TEST_${_ae_curr_exec}_FRIENDLY_NAME")

        cpp_append_global("${_ae_curr_exec}_EXCEPTIONS" "Type: ${exce_type}, Details: ${message}")
        cpp_get_global(_ae_expect_fail "CMAKETEST_TEST_${_ae_curr_exec}_EXPECTFAIL")

        ct_exit("Unexpected exception caught while executing test \"${_ae_curr_exec_friendly_name}\". Type: ${exce_type}, Details: ${message}")

    endfunction()


endfunction()
