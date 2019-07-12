include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/test_section/title)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)
include(cmake_test/detail_/utilities/sanitize_name)

## @memberof TestSection
#  @fn _ct_test_section_test_prefix(handle, result)
#  @brief Assembles the relative file path for the test section.
#
#  Each test section is run in its own directory. This function will assemble
#  the prefix for the this section's directory. The resulting prefix is relative
#  to the test root.
#
#  @param[in] handle The TestSection instance we are generating the prefix for.
#  @param[out] result An identifier to hold the resulting prefix.
function(_ct_test_section_test_prefix _tstp_handle _tstp_result)
    _ct_is_handle(_tstp_handle)
    _ct_nonempty_string(_tstp_result)

    _ct_test_section_get_title(${_tstp_handle} _tstp_title)
    _ct_sanitize_name(_tstp_title "${_tstp_title}")
    _ct_get_prop(${_tstp_handle} _tstp_parent "parent_section")
    if("${_tstp_parent}" STREQUAL "0")
        set(${_tstp_result} "${_tstp_title}")
    else()
        _ct_test_section_test_prefix(${_tstp_parent} ${_tstp_result})
        set(${_tstp_result} "${${_tstp_result}}/${_tstp_title}")
    endif()

    _ct_return(${_tstp_result})
endfunction()
