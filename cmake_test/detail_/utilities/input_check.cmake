include_guard()
include(cmake_test/asserts/list)

#[[[ Asserts that the provided identifier is set to a value other than the empty
#    string.
#
#  This function can be used to assert that an identifier is set to a value. In
#  the event that the input to this function is not an identifier, or if that
#  identifier is not set to a value, this function will raise a fatal error.
#
#  :param _n_var: The identifier to check for defined-ness.
#  :type _n_var: Identifier
#]]
function(_ct_nonempty _n_var)
    cmake_policy(SET CMP0054 NEW)
    if("${${_n_var}}" STREQUAL "")
        message(FATAL_ERROR "${_n_var} is empty.")
    endif()
endfunction()

#[[[ Asserts that the identifier contains a non-empty string.
#
#  This function will ensure that the provided identifier is set to a value and
#  that that value is not the empty string. If the identifier contains a list,
#  or if the identifier is set to an empty string this function will raise a
#  fatal error.
#
#  :param _ns_var: The identifier whose contents is being examined.
#  :type _ns_var: Identifier
#]]
function(_ct_nonempty_string _ns_var)
    _ct_nonempty("${_ns_var}")
    ct_assert_not_list("${_ns_var}")
endfunction()
