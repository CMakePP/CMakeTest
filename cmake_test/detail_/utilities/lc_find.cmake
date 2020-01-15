include_guard()

##[[[ Case-insensitive search for a substring.
#
# This function will search through the string ``${_lf_string}`` for the
# substring ``${_lf_substring}``. If the substring is found than the identifier
# provided as ``${_lf_found}`` will be set to ``TRUE`` otherwise it will be set
# to ``FALSE``.
#
# :param _lf_found: Identifier to hold the result.
# :type _lf_found: Identifier
# :param _lf_substring: The substring we are looking for.
# :type _lf_substring: str
# :param _lf_string: The string we are searching for ``${_lf_substring}`` in.
# :type _lf_string: str
# :returns: ``TRUE`` if the substring is found and ``FALSE`` otherwise. Result
#           is accessible to the caller via ``_lf_found``.
#]]
function(_ct_lc_find _lf_found _lf_substring _lf_string)
    string(TOLOWER "${_lf_string}" _lf_lc_string)
    string(TOLOWER "${_lf_substring}" _lf_lc_substring)

    string(FIND "${_lf_lc_string}" "${_lf_lc_substring}" _lf_pos)
    set(${_lf_found} TRUE PARENT_SCOPE)
    if("${_lf_pos}" STREQUAL "-1")
        set(${_lf_found} FALSE PARENT_SCOPE)
    endif()
endfunction()


