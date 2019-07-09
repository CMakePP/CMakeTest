include_guard()

## @fn ct_assert_defined(var)
#  @brief Asserts that the provided variable is defined.
#
#  This function can be used to assert that a variable is defined. It does not
#  assert that the variable is set to any particular value.
#
#  @param[in] var The identifier to check for defined-ness.
function(ct_assert_defined _ad_var)
    if(NOT DEFINED ${_ad_var})
        message(FATAL_ERROR "${_ad_var} is not defined.")
    endif()
endfunction()

## @fn ct_assert_not_defined(var)
#  @brief Asserts that the provided variable is not defined.
#
#  This function can be used to assert that a variable is not defined.
#
#  @param[in] var The identifier to check for defined-ness.
function(ct_assert_not_defined _and_var)
    if(DEFINED ${_and_var})
        message(FATAL_ERROR "${_and_var} is defined.")
    endif()
endfunction()
