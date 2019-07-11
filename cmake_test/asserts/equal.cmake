include_guard()

## @fn ct_assert_equal(var, contents)
#  @brief Asserts that an identifier contains the specified contents.
#
#  This function is used to assert that a given identifier is set to the
#  specific contents. If the identifier is not set to the specified contents a
#  fatal error will be raised.
#
#  @param[in] var The identifier whose contents are in question.
#  @param[in] contents What the identifier should be set to.
function(ct_assert_equal _ae_var _ae_contents)
    if(NOT "${${_ae_var}}" STREQUAL "${_ae_contents}")
        message(
            FATAL_ERROR
            "Assertion: \"${_ae_var}\" == \"${_ae_contents}\" failed. "
            "${_ae_var} contents: \"${${_ae_var}}\""
        )
    endif()
endfunction()

## @fn ct_assert_not_equal(var, contents)
#  @brief Asserts that an identifier does not contain the specified contents.
#
#  This function is used to assert that a given identifier is set to something
#  other than the specified contents. If the identifier is set to the specified
#  contents a fatal error will be raised.
#
#  @param[in] var The identifier whose contents are in question.
#  @param[in] contents What the identifier should not be set to.
function(ct_assert_not_equal _ane_var _ane_content)
    if("${${_ane_var}}" STREQUAL "${_ane_content}")
        message(
            FATAL_ERROR
           "Assertion: \"${_ane_var}\" != \"${_ane_content}\" failed. "
           "${_ane_var} contents: \"${${_ane_var}}\""
        )
    endif()
endfunction()
