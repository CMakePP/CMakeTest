include_guard()
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_state/add_prop)
include(cmake_test/detail_/test_state/get_prop)

## @memberof TestState
#  @public
#  @fn ADD_SECTION(handle, name)
#  @brief Adds a subsection to the current test.
#
#  Subsections create new unit testing scope. The new scope includes everything
#  from the outer scope as well as the contents of the added section (less any
#  subsections added in that content). When the new scope ends the contents of
#  that section are removed from the test's content. This function makes the
#  new scope which includes a new layer for:
#
#  - content,
#  - section titles,
#  - output assertions, and
#  - whether that layer should pass
#
#  @param[in] handle The handle to the TargetState object
#  @param[in] name   The name of the new section
function(_ct_test_state_add_section _tsas_handle _tsas_name)
    _ct_variable_is_set(_tsas_handle "Object must be set")
    _ct_variable_is_set(_tsas_name "Section name can not be empty")

    # section_titles always has an entry
    _ct_get_prop(_tsas_titles ${_tsas_handle} "section_titles")
    list(APPEND _tsas_titles "${_tsas_name}")
    _ct_add_prop(${_tsas_handle} "section_titles" "${_tsas_titles}")

    # test_content could be empty
    _ct_get_prop(_tsas_array ${_tsas_handle} "test_content")
    list(LENGTH _tsas_array _tsas_length)
    if("${_tsas_length}" STREQUAL "0")
        set(_tsas_array "" "")
    else()
        list(APPEND _tsas_array "")
    endif()
    _ct_add_prop(${_tsas_handle} "test_content" "${_tsas_array}")

    # passert_per_level needs a 0
    _ct_get_prop(_tsas_asserts ${_tsas_handle} "passert_per_level")
    list(APPEND _tsas_asserts 0)
    _ct_add_prop(${_tsas_handle} "passert_per_level" "${_tsas_asserts}")

    # should_pass needs to be set to previous value
    _ct_get_prop(_tsas_sp ${_tsas_handle} "should_pass")
    list(GET _tsas_sp -1 _tsas_elem)
    list(APPEND _tsas_sp "${_tsas_elem}")
    _ct_add_prop(${_tsas_handle} "should_pass" "${_tsas_sp}")

endfunction()
