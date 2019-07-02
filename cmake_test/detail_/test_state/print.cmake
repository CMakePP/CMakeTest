include_guard()
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_state/depth)
include(cmake_test/detail_/test_state/get_content)
include(cmake_test/detail_/test_state/get_prop)
include(cmake_test/detail_/test_state/title)

## @memberof TestState
#  @public
#  @fn PRINT(TestState)
#  @brief Prints out the provided TestState's state.
#
#  This function is intendeded primarily for debugging purposes. It will print
#  to standard out the current stte of the TestState instance.
#
#  @param[in] handle The handle to the TestState object
function(_ct_test_state_print _tsp_handle)
    _ct_variable_is_set(_tsp_handle "Must provide a valid handle")

    # Loop over single value attributes
    foreach(_tsp_attribute "test_name" "test_number")
        _ct_get_prop(_tsp_buffer ${_tsp_handle} "${_tsp_attribute}")
        message("${_tsp_attribute}: ${_tsp_buffer}")
    endforeach()

    _ct_test_state_current_depth(${_tsp_handle} _tsp_depth)
    message("Current depth: ${_tsp_depth}")

    _ct_test_state_get_title(${_tsp_handle} _tsp_section)
    message("Current section title: ${_tsp_section}")

    _ct_test_state_should_pass(${_tsp_handle} _tsp_should_pass)
    message("Tests in current section should pass: ${_tsp_should_pass}")

    _ct_get_prop(_tsp_lengths ${_tsp_handle} "passert_per_level")
    message("Print assert per level: ${_tsp_lengths}")

    _ct_get_prop(_tsp_buffer ${_tsp_handle} "print_assert")
    message("Test output must contain:")
    foreach(_tsp_print ${_tsp_buffer})
        message("  - \"${_tsp_print}\"")
    endforeach()

    _ct_test_state_get_content(${_tsp_handle} _tsp_content)
    message("Current section content: ${_tsp_content}")
endfunction()
