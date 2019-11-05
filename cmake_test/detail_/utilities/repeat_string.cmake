include_guard()
include(cmake_test/detail_/utilities/return)

#[[[ Creates a string by repeating a substring
#
# This function is used to create a new string by repeating a substring a
# specified number of times. This is useful for creating the proper indents
# for printing and for creating repeated characters like in banners.
#
# :param _rs_result: An identifier to save the result to.
# :type _rs_result: Identifier
# :param _rs_str: The substring to repeat.
# :type _rs_str: String
# :param  _rs_n: The number of times to repeat ``${_rs_str}``.
# :type _rs_n: String
#]]
function(_ct_repeat_string _rs_result _rs_str _rs_n)
    set(_rs_counter 0)
    while("${_rs_counter}" LESS "${_rs_n}")
        set(${_rs_result} "${${_rs_result}}${_rs_str}")
        math(EXPR _rs_counter "${_rs_counter} + 1")
    endwhile()
    _ct_return(${_rs_result})
endfunction()
