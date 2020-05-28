include_guard()

#[[[ Asserts that the file at the provided path exists.
#
# :param _afe_path: The path to check
# :type _afe_path: Path
#]]
function(ct_assert_file_exists _afe_path)
    if(NOT EXISTS "${_afe_path}")
        message(FATAL_ERROR "File does not exist at ${_afe_path}.")
    elseif(IS_DIRECTORY "${_afe_path}")
        message(FATAL_ERROR "${_afe_path} is a directory not a file.")
    endif()
endfunction()

#[[[ Asserts that a file does not exist at the provided path.
#
# :param _afdne_path: The path to check
# :type _afdne_path: Path
#]]
function(ct_assert_file_does_not_exist _afdne_path)
    if(EXISTS "${_afdne_path}" AND NOT IS_DIRECTORY "${_afdne_path}")
        message(FATAL_ERROR "File does exist at ${_afdne_path}.")
    endif()
endfunction()
