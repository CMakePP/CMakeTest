include_guard()

## @fn ct_assert_string(var)
#  @brief Asserts that an identifier contains a string
#
#  For our purposes a string is anything that is not a list (a list being a
#  string that contains at least one unescaped semicolon). Consequentially, this
#  function is more-or-less equivalent to ct_assert_not_list.
#
#  @param[in] var The identifier we want the stringy-ness of.
function(ct_assert_string _as_var)
    list(LENGTH ${_as_var} _as_length)
    if("${_as_length}" GREATER 1)
        message(FATAL_ERROR "${_as_var} is list: ${${_as_var}}")
    endif()
endfunction()

## @fn ct_assert_not_string(var)
#  @brief Asserts that an identifier does not contain a string
#
#  For our purposes a string is anything that is not a list (a list being a
#  string that contains at least one unescaped semicolon). Consequentially, this
#  function is more-or-less equivalent to ct_assert_list.
#
#  @param[in] var The identifier we want the stringy-ness of.
function(ct_assert_not_string _ans_var)
    list(LENGTH ${_ans_var} _ans_length)
    if("${_ans_length}" LESS 2)
        message(FATAL_ERROR "${_ans_var} is string: ${${_ans_var}}")
    endif()
endfunction()
