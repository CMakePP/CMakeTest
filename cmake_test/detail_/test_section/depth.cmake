include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)
include(cmake_test/detail_/test_section/private)

#[[[ Determines how nested the current section is.
#
# Particularly for printing, it is useful to know how nested a section is. This
# function computes the nesting by recursing until a section with no parent is
# found. The number of recursions necessary is in turn the depth.
#
# :param _tsd_handle: The TestSection we want to know the depth of.
# :type _tsd_handle: TestSection
# :param[out] _tsd_depth: An identifier to set to the current section's depth.
# :type _tsd_depth: str
# :returns: The depth, as an integer, accessible via ``${_tsd_depth}``.
#]]
function(_ct_test_section_depth _tsd_handle _tsd_depth)
    _ct_is_handle(_tsd_handle)
    _ct_nonempty_string(_tsd_depth)

    set(${_tsd_depth} 0)
    _ct_get_prop(${_tsd_handle} _tsd_parent "parent_section")
    while(NOT "${_tsd_parent}" STREQUAL "0")
        math(EXPR ${_tsd_depth} "${${_tsd_depth}} + 1")
        _ct_get_prop(${_tsd_parent} _tsd_parent "parent_section")
    endwhile()
    _ct_return(${_tsd_depth})
endfunction()
