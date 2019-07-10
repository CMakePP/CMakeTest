include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/test_section/depth)
include(cmake_test/detail_/test_section/title)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/repeat_string)

## @memberof TestSection
#  @public
#  @fn ADD_SECTION(handle, child, name)
#  @brief Creates a subsection of the provided parent section
#
#  Subsections create new unit testing scope. The new scope includes everything
#  from the outer scope as well as the contents of the added section (less any
#  subsections added in that content).
#
#  @param[in] handle The TestSection object to add the section to
#  @param[out] child The handle of the new section
#  @param[in] name   The name of the new section
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
    _ct_test_section_ctor(${_tsas_child} "${_tsas_name}")
    _ct_add_prop(${${_tsas_child}} "parent_section" ${_tsas_handle})
    _ct_return(${_tsas_child})
endfunction()
