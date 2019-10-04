include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/test_section/depth)
include(cmake_test/detail_/test_section/title)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/repeat_string)

#[[[ Creates a subsection of the provided parent section
#
# Subsections create new unit testing scope such that the contents of the new
# subsection are not visible to the outer section, whereas the contents of the
# outer section are visible to the new subsection. This function creates a new
# subsection of the provided section.
#
# :param _tsas_handle: The instance holding the contents of the unit test.
# :type _tsas_handle: TestSection
# :param _tsas_child: A TestSection instance with a copy of ``_tsas_handle``'s
#                     contents, but a new scope.
# :type _tsas_child: TestSection
# :param _tsas_name: The name of the new section we are creating
# :type _tsas_name: str
# :returns: The new TestSection instance via the ``_tsas_child`` handle.
#
#]]
function(_ct_test_section_add_section _tsas_handle _tsas_child _tsas_name)
    # Check inputs
    _ct_is_handle(_tsas_handle)
    _ct_nonempty_string(_tsas_child)
    _ct_nonempty_string(_tsas_name)

    # Print the section's title
    _ct_test_section_depth(${_tsas_handle} _tsas_depth)
    _ct_test_section_get_title(${_tsas_handle} _tsas_ptitle)
    _ct_get_prop(${_tsas_handle} _tsas_printed "printed")
    if(NOT _tsas_printed)
        _ct_repeat_string(_tsas_tab "    " ${_tsas_depth})
        message("${_tsas_tab}${_tsas_ptitle}:")
        _ct_add_prop(${_tsas_handle} "printed" TRUE)
    endif()

    # Create the new section and return it
    _ct_test_section_ctor(${_tsas_child} "${_tsas_name}" ${_tsas_handle})
    _ct_return(${_tsas_child})
endfunction()
