include_guard()

#[[[ Asserts that the provided variable is true.
#
# :param _at_var: The identifier to check for trueness.
# :type _at_var: Identifier
#]]
function(ct_assert_true _at_var)
    if(NOT ${_at_var})
        message(FATAL_ERROR "${_at_var} is not true.")
    endif()
endfunction()

#[[[ Asserts that the provided variable is false.
#
# :param _af_var: The identifier to check for falseness.
# :type _af_var: Identifier
#]]
function(ct_assert_false _af_var)
    if(${_af_var})
        message(FATAL_ERROR "${_af_var} is not false.")
    endif()
endfunction()
