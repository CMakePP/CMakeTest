include_guard()
include(cmake_test/asserts/file_exists)

#[[[ Assert a file contains the specified text.
#
# Asserts that the file at the specified path contains the specified text.
#
# :param _afc_file: The file to check
# :type _afc_file: Path
# :param _afc_text: The text to check for
# :type _afc_text: String
#]]
function(ct_assert_file_contains _afc_file _afc_text)
    # Ensure the file exists
    ct_assert_file_exists("${_afc_file}")

    # Read the file and ensure it contains the text
    file(READ "${_afc_file}" _afc_contents)
    string(FIND "${_afc_contents}" "${_afc_text}" _afc_res)
    if(${_afc_res} EQUAL -1)
        message(
            FATAL_ERROR
            "File at ${_afc_file} does not contain text \"${_afc_text}\""
        )
    endif()
endfunction()

#[[[ Assert a file does not contain the specified text.
#
# Asserts that the file at the specified path does not contain the specified
# text.
#
# :param _afdnc_file: The file to check
# :type _afdnc_file: Path
# :param _afdnc_text: The text to check for
# :type _afdnc_text: String
#]]
function(ct_assert_file_does_not_contain _afdnc_file _afdnc_text)
    # Ensure the file exists
    ct_assert_file_exists("${_afdnc_file}")

    # Read the file and ensure it does not contain the text
    file(READ "${_afdnc_file}" _adnfc_contents)
    string(FIND "${_adnfc_contents}" "${_afdnc_text}" _afdnc_res)
    if(NOT ${_afdnc_res} EQUAL -1)
        message(
            FATAL_ERROR
            "File at ${_afdnc_file} contains text \"${_afdnc_text}\""
    )
    endif()
endfunction()
