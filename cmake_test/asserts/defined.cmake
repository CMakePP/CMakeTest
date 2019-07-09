include_guard()

## @fn ct_assert_defined(var)
#  @brief Asserts that the provided variable is defined.
#
#
function(ct_assert_defined _ad_var)
    if(NOT DEFINED ${_ad_var})
        message(FATAL_ERROR "${_ad_var} is not defined.")
    endif()
endfunction()
