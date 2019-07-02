include_guard()
include(cmake_test/detail_/test_state/add_prop)
include(cmake_test/detail_/test_state/get_prop)

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
function(_ct_test_state_end_section _tses_handle)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements
    _ct_test_state_current_depth(${_tses_handle} _tses_depth)
    if("${_tses_depth}" STREQUAL "0")
        message(FATAL_ERROR "No section to end")
    endif()

    # Print_assert needs to be rolled back specially
    _ct_get_prop(_tses_nassert_per_level ${_tses_handle} "passert_per_level")
    _ct_get_prop(_tses_asserts ${_tses_handle} "print_assert")
    list(GET _tses_nassert_per_level -1 _tses_nassert)
    while("${_tses_nassert}" GREATER "0")
        list(REMOVE_AT _tses_asserts -1)
        math(EXPR _tses_nassert "${_tses_nassert} - 1")
    endwhile()
    _ct_add_prop(${_tses_handle} "print_assert" "${_tses_asserts}")

    set(_tses_arrays "section_titles" "test_content" "passert_per_level"
                     "should_pass")
    foreach(_tses_array_i  ${_tses_arrays})
        _ct_get_prop(_tses_array ${_tses_handle} "${_tses_array_i}")
        list(REMOVE_AT _tses_array -1)
        _ct_add_prop(${_tses_handle} "${_tses_array_i}" "${_tses_array}")
    endforeach()
endfunction()
