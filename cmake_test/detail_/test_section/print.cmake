include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/test_section/depth)
include(cmake_test/detail_/test_section/get_prop)

## @memberof TestSection
#  @public
#  @fn PRINT(handle)
#  @brief Prints out the provided TestState's state.
#
#  This function is intendeded primarily for debugging purposes. It will print
#  to standard out the state (including the state of all parent sections) of the
#  current section.
#
#  @param[in] handle The handle to the TestSection object
function(_ct_test_section_print _tsp_handle)
    _ct_is_handle(_tsp_handle)

    # Print the hierarchy up to this section
    _ct_get_prop(_tsp_parent ${_tsp_handle} "parent_section")
    if(NOT "${_tsp_parent}" STREQUAL "0")
        _ct_test_section_print(${_tsp_parent})
    endif()

    # Get the indentation for this section
    _ct_test_section_depth(${_tsp_handle} _tsp_depth)
    set(_tsp_tabs "")
    set(_tsp_counter 0)
    while("${_tsp_counter}" LESS "${_tsp_depth}")
        set(_tsp_tabs "${_tsp_tabs}    ")
        math(EXPR _tsp_counter "${_tsp_counter} + 1")
    endwhile()

    # Get this section's properties
    _ct_get_prop(_tsp_title ${_tsp_handle} "title")
    _ct_get_prop(_tsp_pass ${_tsp_handle} "should_pass")
    _ct_get_prop(_tsp_prints ${_tsp_handle} "print_assert")
    _ct_get_prop(_tsp_content ${_tsp_handle} "content")

    # Print this section out
    message("${_tsp_tabs}${_tsp_title}:")
    message("    ${_tsp_tabs}Should pass?: ${_tsp_pass}")
    message("    ${_tsp_tabs}Print Asserts:")
    foreach(_tsp_assert ${_tsp_prints})
        message("    ${_tsp_tabs}  - \"${_tsp_assert}\"")
    endforeach()
    message("    ${_tsp_tabs}Content: ${_tsp_content}")
endfunction()
