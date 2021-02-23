include_guard()

#[[[ Asserts that an identifier contains the specified contents.
#
#  This function is used to assert that a given identifier is set to the
#  specific contents. If the identifier is not set to the specified contents a
#  fatal error will be raised.
#
#  :param _ae_var: The identifier whose contents are in question.
#  :type _ae_var: Identifier
#  :param _ae_contents: What the identifier should be set to.
#  :type _ae_contents: String
#]]
function(ct_assert_equal _ae_var _ae_contents)
    if(NOT "${${_ae_var}}" STREQUAL "${_ae_contents}")
        cpp_raise(
            ASSERTION_FAILED
            "Assertion: ${${_ae_var}} == ${_ae_contents} failed. "
            "${_ae_var} contents: ${${_ae_var}}"
        )
    endif()
endfunction()

#[[[ Asserts that an identifier does not contain the specified contents.
#
# This function is used to assert that a given identifier is set to something
# other than the specified contents. If the identifier is set to the specified
# contents a fatal error will be raised.
#
# :param _ane_var: The identifier whose contents are in question.
# :type _ane_var: Identifier
# :param _ane_contents: What the identifier should not be set to.
# :type _ane_contents: String
#]]
function(ct_assert_not_equal _ane_var _ane_content)
    if("${${_ane_var}}" STREQUAL "${_ane_content}")
        cpp_raise(
           ASSERTION_FAILED
           "Assertion: ${${_ane_var}} != ${_ane_content} failed. "
           "${_ane_var} contents: ${${_ane_var}}"
        )
    endif()
endfunction()
