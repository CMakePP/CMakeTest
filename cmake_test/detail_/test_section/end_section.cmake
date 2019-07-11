include_guard()
include(cmake_test/detail_/test_section/private)

## @memberof TestState
#  @public
#  @fn END_SECTION(handle, parent)
#  @brief Ends the current section
#
#  This function signals that we are done with the current test section.
#
#  @param[in] handle The TestState instance we are ending the section of.
function(_ct_test_section_end_section _tses_handle _tses_parent)
    _ct_is_handle(_tses_handle)
    _ct_nonempty_string(_tses_parent)

    #cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    # Get the parent section, if it's 0 there's a syntax error
    _ct_get_prop("${_tses_handle}" ${_tses_parent} "parent_section")
    if("${${_tses_parent}}" STREQUAL "0")
        message(FATAL_ERROR "Provided TestSection is not a section")
    endif()
    _ct_return(${_tses_parent})
endfunction()
