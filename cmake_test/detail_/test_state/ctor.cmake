include_guard()
include(cmake_test/detail_/utilities) # variable_is_set and return
include(cmake_test/detail_/test_state/add_prop)

## @memberof TestState
#  @public
#  @fn CTOR(TestState, String)
#  @brief Creates a TestState instance for the provided unit test
#
#  This function wraps the process of creating a TestState object. This includes
#  creating the "this pointer" and adding the appropriate attributes to the
#  instance. The TestState class's attributes are:
#
#  - test_number : A running tally of the number of tests
#  - section_titles : list where value i is depth i's contribution to the title
#  - test_content : list where value i is depth i's code content
#  - print_assert : jagged matrix of strings where element i, j is the j-th
#                   string that must appear for tests at depths of i or greater.
#  - passert_per_level : list where value i is the number of printing assert at
#                        depth i
#  - should_pass : list such that element i is whether depth i should run
#                  successfully or error.
#
#
#  @note If you add an attribute you likely need to update add_section and
#        end_section.
#
# @param[out] handle A variable for the newly created TestState's handle.
# @param[in] name The name of the unit test that this TestState is for.
function(_ct_test_state_ctor _tsc_handle _tsc_name)
    _ct_variable_is_set(_tsc_handle "Returned object name can not be empty")
    _ct_variable_is_set(_tsc_name "Test name can not be empty")

    string(RANDOM _tsc_temp_handle) #Basically our this pointer

    # Add properties to our class

    # A running total of the number of tests we've added
    _ct_add_prop("${_tsc_temp_handle}" "test_number" 0)

    # A list of section titles we've come across length of which is our depth
    # + 1
    _ct_add_prop("${_tsc_temp_handle}" "section_titles" "${_tsc_name}")

    # A list of test content
    _ct_add_prop("${_tsc_temp_handle}" "test_content" "")

    # A list of strings per depth level that must appear in output
    _ct_add_prop("${_tsc_temp_handle}" "print_assert" "")

    # The number of print asserts per depth level
    _ct_add_prop("${_tsc_temp_handle}" "passert_per_level" "0")

    # A list of whether each depth should pass
    _ct_add_prop("${_tsc_temp_handle}" "should_pass" "TRUE")

    set(${_tsc_handle} ${_tsc_temp_handle})
    _ct_return(${_tsc_handle})
endfunction()
