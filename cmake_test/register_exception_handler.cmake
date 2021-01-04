function(ct_register_exception_handler)
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)

        cpp_get_global(_ae_curr_exec "CT_CURRENT_EXECUTION_UNIT")
        cpp_get_global(_ae_curr_exec_friendly_name "CMAKETEST_TEST_${_ae_curr_exec}_FRIENDLY_NAME")
        #get_property(curr_exceptions GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS")

        #list(APPEND curr_exceptions "Type: ${exce_type}, Details: ${message}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS" "${curr_exceptions}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTION_DETAILS" "Type: ${exce_type}, Details: ${message}")

        cpp_append_global("${_ae_curr_exec}_EXCEPTIONS" "Type: ${exce_type}, Details: ${message}")
        cpp_get_global(_ae_expect_fail "CMAKETEST_TEST_${_ae_curr_exec}_EXPECTFAIL")
        #if(NOT _ae_expect_fail)
            ct_exit("Unexpected exception caught while executing test \"${_ae_curr_exec_friendly_name}\". Type: ${exce_type}, Details: ${message}")
        #endif()
    endfunction()


endfunction()
