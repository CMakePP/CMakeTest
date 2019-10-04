include_guard()
include(cmake_test/detail_/test_section/private)

#[[[ Ends the current section.
#
# This function signals that we are done with the current test section. Calling
# this with the top-level unit test section will raise an error. Ending a
# section basically just wraps the process of getting the section's parent
# section.
#
# :param _tses_handle: The TestState instance we are ending the section of.
# :type _tses_handle: TestState
# :param _tses_parent: An identifier to hold the new current section
# :type _tses_parent: str
# :returns: The TestState instance that ``_tses_handle`` is a child section of.
#           The resulting instance is accessible via ``${${_tses_parent}}``.
#]]
function(_ct_test_section_end_section _tses_handle _tses_parent)
    _ct_is_handle(_tses_handle)
    _ct_nonempty_string(_tses_parent)

    # Get the parent section, if it's 0 there's a syntax error
    _ct_get_prop("${_tses_handle}" ${_tses_parent} "parent_section")
    if("${${_tses_parent}}" STREQUAL "0")
        message(FATAL_ERROR "Provided TestSection is not a section")
    endif()
    _ct_return(${_tses_parent})
endfunction()
