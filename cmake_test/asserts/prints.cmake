include_guard()

#[[[ Asserts that a specified message was printed.
#
# This function is used to assert that a string was printed immediately
# prior to this function call. This function only compares the expected
# message with whatever was printed last, it does not compare with
# any printed messages further back.
#
# :param _ap_msg: The message expected to have been printed.
# :type _ap_msg: String
#]]
function(ct_assert_prints _ap_msg)
    cpp_get_global(_ap_last_msg CT_LAST_MESSAGE)
    if(NOT ("${_ap_msg}" STREQUAL "${_ap_last_msg}"))
        cpp_raise(
            ASSERTION_FAILED
            "Assertion: Print failed.
            Expected: ${_ap_msg}
            Last message: ${_ap_last_msg}"
        )
    endif()


endfunction()
