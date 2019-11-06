include_guard()

#[[[ Asserts that the provided variable is defined.
#
# This function can be used to assert that a variable is defined. It does not
# assert that the variable is set to any particular value. If the variable is
# not defined it will raise an error.
#
# :param _ad_var: The identifier to check for defined-ness.
# :type _ad_var: Identifier
#]]
function(ct_assert_defined _ad_var)
    if(NOT DEFINED ${_ad_var})
        message(FATAL_ERROR "${_ad_var} is not defined.")
    endif()
endfunction()

#[[[ Asserts that the provided variable is not defined.
#
# This function can be used to assert that a variable is not defined. If the
# variable is actually defined this function will raise an error.
#
# :param _and_var: The identifier to check for defined-ness.
# :type _and_var: Identifier
#]]
function(ct_assert_not_defined _and_var)
    if(DEFINED ${_and_var})
        message(FATAL_ERROR "${_and_var} is defined.")
    endif()
endfunction()
