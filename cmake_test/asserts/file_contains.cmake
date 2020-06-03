include_guard()
include(cmake_test/asserts/file_exists)

#[[[ Assert a file contains the specified text.
#
# Asserts that the file at the specified path contains the specified text.
#
# :param _afc_file: The file to check
# :type _afc_file: path
# :param _afc_text: The text to check for
# :type _afc_text: string
#]]
function(ct_assert_file_contains _afc_file _afc_text)
    # Ensure the file exists
    ct_assert_file_exists("${_afc_file}")

    # Throw error if the file does not contain the text
    ct_file_contains(_afc_result "${_afc_file}" "${_afc_text}")
    if(NOT _afc_result)
        message(
            FATAL_ERROR
            "File at ${_afc_file} does not contain text \"${_afc_text}\"."
        )
    endif()
endfunction()

#[[[ Assert a file does not contain the specified text.
#
# Asserts that the file at the specified path does not contain the specified
# text.
#
# :param _afdnc_file: The file to check
# :type _afdnc_file: path
# :param _afdnc_text: The text to check for
# :type _afdnc_text: string
#]]
function(ct_assert_file_does_not_contain _afdnc_file _afdnc_text)
    # Ensure the file exists
    ct_assert_file_exists("${_afdnc_file}")

    # Throw error if the file contains the text
    ct_file_contains(_afdnc_result "${_afdnc_file}" "${_afdnc_text}")
    if(_afdnc_result)
        message(
            FATAL_ERROR
            "File at ${_afdnc_file} contains text \"${_afdnc_text}\"."
        )
    endif()
endfunction()

#[[[ Determines if a file contains some text.
#
# This function checks whether a file contains some text and returns a boolean
# result.
#
# :param _fc_result: Name to use for the variable which will hold the result.
# :type _fc_result: bool
# :param _fc_file: The file to check.
# :type _fc_file: string
# :param _fc_text: The text to check for.
# :type _fc_text: string
# :returns: ``_fc_result`` will be set to ``TRUE`` if file contains the text
            and ``FALSE`` if it does not.
# :rtype: bool
#]]
function(ct_file_contains _fc_result _fc_file _fc_text)
    # Read the file to determine if it contains the text
    file(READ "${_fc_file}" _fc_contents)
    string(FIND "${_fc_contents}" "${_fc_text}" _fc_index)
    if(${_fc_index} EQUAL -1)
        set("${_fc_result}" FALSE PARENT_SCOPE)
    else()
        set("${_fc_result}" TRUE PARENT_SCOPE)
    endif()
endfunction()
