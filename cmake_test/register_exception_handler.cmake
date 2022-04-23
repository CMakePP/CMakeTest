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


        ct_exit("Unexpected exception caught while executing test \"${_ae_curr_exec_friendly_name}\". Type: ${exce_type}, Details: ${message}")

    endfunction()


endfunction()
