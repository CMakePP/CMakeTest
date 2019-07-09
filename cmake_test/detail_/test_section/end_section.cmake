include_guard()
include(cmake_test/detail_/test_section/add_prop)
include(cmake_test/detail_/test_section/get_prop)

## @memberof TestState
#  @public
#  @fn END_SECTION(handle)
#  @brief Ends the current section
#
#  Testing works by internally keeping the test's state in a first-in-last-out
#  container. The `ADD_SECTION` member function adds a layer to that container
#  and  the `END_SECTION` member function pops that layer off.
#
#  @param[in] handle The TestState instance we are ending the section of.
function(_ct_test_section_end_section _tses_handle _tses_parent)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    _ct_get_prop(${_tses_parent} "${_tses_handle}" "parent_section")
    _ct_return(${_tses_parent})
endfunction()
