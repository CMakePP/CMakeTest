include_guard()

## @fn _ct_lc_find(found, substring, string)
#  @brief Case-insensitive search for a substring.
#
#  @param[out] found An identifier to hold the result.
#  @param[in] substring The set of characters we are looking for in @p string.
#  @param[in] string The string we are searching for @p substring
function(_ct_lc_find _lf_found _lf_substring _lf_string)
    string(TOLOWER "${_lf_string}" _lf_lc_string)
    string(TOLOWER "${_lf_substring}" _lf_lc_substring)

    string(FIND "${_lf_lc_string}" "${_lf_lc_substring}" _lf_pos)
    set(${_lf_found} TRUE PARENT_SCOPE)
    if("${_lf_pos}" STREQUAL "-1")
        set(${_lf_found} FALSE PARENT_SCOPE)
    endif()
endfunction()


