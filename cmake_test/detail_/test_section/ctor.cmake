include_guard()
include(cmake_test/detail_/utilities/return)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/test_section/private)

## @memberof TestSection
#  @public
#  @fn CTOR(handle, name)
#  @brief Creates a TestState instance for the provided unit test
#
#  This function wraps the process of creating a TestSection object. This
#  includes  creating the "this pointer" and adding the appropriate attributes
#  to the instance. The TestSection class's attributes are:
#
#  - title : The title of the section
#  - content: A list of CMake code in the section
#  - print_assert: A list of strings that must be in the output
#  - should_pass: Should the current section pass
#  - parent_section: A handle to the this section's supersection
#  - printed: Has the title of this section been printed
#    - needed to avoid printing section's title everytime we add a section
#
# @param[out] handle The identifier to hold the object's handle
# @param[in] name The name of this section.
function(_ct_test_section_ctor _tsc_handle _tsc_name)
    _ct_nonempty(_tsc_handle)
    _ct_nonempty_string(_tsc_name)

    string(RANDOM _tsc_temp_handle) #Basically our this pointer
    set(_tsc_temp_handle "${_tsc_temp_handle}_test_section")

    # Add properties to our class
    # Title of the section
    _ct_add_prop(${_tsc_temp_handle} "title" "${_tsc_name}")

    # A list of test content
    _ct_add_prop(${_tsc_temp_handle} "content" "")

    # A list of strings that must appear in the output
    _ct_add_prop(${_tsc_temp_handle} "print_assert" "")

    # Whether this section should pass
    _ct_add_prop(${_tsc_temp_handle} "should_pass" "TRUE")

    # A list of subsections
    _ct_add_prop(${_tsc_temp_handle} "parent_section" "0")

    # Has title been printed
    _ct_add_prop(${_tsc_temp_handle} "printed" FALSE)

    set(${_tsc_handle} ${_tsc_temp_handle})
    _ct_return(${_tsc_handle})
endfunction()
