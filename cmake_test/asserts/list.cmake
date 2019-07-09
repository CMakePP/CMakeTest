include_guard()

## @fn ct_assert_list(var)
#  @brief Asserts that an identifier contains a list.
#
#  For our purposes a list is defined as a string that contains one or more,
#  unescaped semicolons. While a string with no semicolons is usable as if it is
#  a single element list (or a zero element list if it is the empty string) this
#  function will not consider such strings lists.
#
#  @param[in] var The identifier we want to know the list-ness of.
function(ct_assert_list _anl_var)
    list(LENGTH ${_anl_var} _anl_length)
    if("${_anl_length}" LESS 2)
        message(
            FATAL_ERROR "${_anl_var} is not a list. Contents: ${${_anl_var}}"
        )
    endif()
endfunction()

## @fn ct_assert_not_list(var)
#  @brief Asserts that an identifier does not contain a list.
#
#  For our purposes a list is defined as a string that contains one or more,
#  unescaped semicolons. While a string with no semicolons is usable as if it is
#  a single element list (or a zero element list if it is the empty string) this
#  function will not consider such strings lists.
#
#  @param[in] var The identifier we want to know the list-ness of.
function(ct_assert_not_list _anl_var)
    list(LENGTH ${_anl_var} _anl_length)
    if("${_anl_length}" GREATER 1)
        message(FATAL_ERROR "${_anl_var} is list: ${${_anl_var}}")
    endif()
endfunction()
