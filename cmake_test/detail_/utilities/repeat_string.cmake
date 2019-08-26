include_guard()
include(cmake_test/detail_/utilities/return)

## @fn _ct_repeat_string(result, str, n)
#  @memberof utilities
#  @brief Creates a string by repeating a substring
#
#  This function is used to create a new string by repeating a substring a
#  specified number of times. This is useful for creating the proper indents
#  for printing and for creating repeated characters like in banners.
#
#  @param[out] result An identifier to save the result to.
#  @param[in]  str    The substring to repeat.
#  @param[in]  n      The number of times to repeat @p str
function(_ct_repeat_string _rs_result _rs_str _rs_n)
    set(_rs_counter 0)
    while("${_rs_counter}" LESS "${_rs_n}")
        set(${_rs_result} "${${_rs_result}}${_rs_str}")
        math(EXPR _rs_counter "${_rs_counter} + 1")
    endwhile()
    _ct_return(${_rs_result})
endfunction()
