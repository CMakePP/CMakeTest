include_guard()
include(cmake_test/asserts/list)

## @fn _ct_nonempty(var)
#  @brief Asserts that the provided identifier is set to a value other than the
#         empty string.
#
#  This function can be used to assert that an identifier is set to a value. In
#  the event that the input to this function is not an identifier, or if that
#  identifier is not set to a value, this function will raise a fatal error.
#
#  @param[in] var The identifier to check for defined-ness.
function(_ct_nonempty _n_var)
    cmake_policy(SET CMP0054 NEW)
    if("${${_n_var}}" STREQUAL "")
        message(FATAL_ERROR "${_n_var} is empty.")
    endif()
endfunction()

## @fn _ct_nonempty_string(var)
#  @brief Asserts that the identifier contains a non-empty string.
#
#  This function will ensure that the provided identifier is set to a value and
#  that that value is not the empty string. If the identifier contains a list,
#  or if the identifier is set to an empty string this function will raise a
#  fatal error.
#
#  @param[in] var The identifier whose contents is being examined.
function(_ct_nonempty_string _ns_var)
    _ct_nonempty("${_ns_var}")
    ct_assert_not_list("${_ns_var}")
endfunction()

## @fn _ct_is_handle(var)
#  @brief Asserts that the identifier is a handle to a TestSection instance
#
#  This function will ensure that the provided identifier is a handle to a
#  TestSection instance. Under the hood this entails ensuring that the
#  identifier is set to a string value, and that the string value contains the
#  substring "test_section". Consequentially, this function is easy to violate
#  with malicious intent, but should reliably catch accidental coding errors.
#
#  @param[in] var The identifier which must be a TestSection instance.
function(_ct_is_handle _ih_var)
    _ct_nonempty_string(${_ih_var})
    string(FIND "${${_ih_var}}" "test_section" _ih_result)
    if("${_ih_result}" STREQUAL "-1")
        message(FATAL_ERROR "${_ih_var} is not a handle to a TestSection.")
    endif()
endfunction()
