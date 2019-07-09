include_guard()

## @fn _ct_nonempty(var)
#  @brief Asserts that the provided variable is defined.
#
#  This function can be used to assert that a variable is defined. It does not
#  assert that the variable is set to any particular value.
#
#  @param[in] var The identifier to check for defined-ness.
function(_ct_nonempty _n_var)
    cmake_policy(SET CMP0054 NEW)
    if("${${_n_var}}" STREQUAL "")
        message(FATAL_ERROR "${_n_var} is empty.")
    endif()
endfunction()

function(_ct_nonempty_string _ns_str)
    _ct_nonempty(${_ns_str})
    list(LENGTH ${_ns_str} _ns_length)
    if("${_ns_length}" GREATER "1")
        message(FATAL_ERROR "${_ns_str} is set to list: ${${_ns_str}}")
    endif()
endfunction()

function(_ct_is_handle _ih_handle)
    _ct_nonempty_string(${_ih_handle})
endfunction()
