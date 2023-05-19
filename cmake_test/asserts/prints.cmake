include_guard()

#[[[ Asserts that a specified message was printed.
#
# This function is used to assert that a string was printed immediately
# prior to this function call. This function only compares the expected
# message with whatever was printed last, it does not compare with
# any printed messages further back.
#
# If the previously printed message does not exactly match the expected message,
# this function will treat the expected message as a regex to check if it matches.
#
# :param _ap_msg: The message expected to have been printed, either exact match or regex.
# :type _ap_msg: String
#]]
function(ct_assert_prints _ap_msg)
    cpp_get_global(_ap_last_msg CT_LAST_MESSAGE)
    if(NOT ("${_ap_last_msg}" STREQUAL "${_ap_msg}"))
        #Have to have MATCHES in separate if()
        #because even if OR is short-circuited
        #CMake tries to compile the regex anyways

        if(NOT ("${_ap_last_msg}" MATCHES "${_ap_msg}"))
            cpp_raise(
                ASSERTION_FAILED
                "Assertion: Print failed.
                Expected: ${_ap_msg}
                Last message: ${_ap_last_msg}"
            )
        endif()
    endif()


endfunction()