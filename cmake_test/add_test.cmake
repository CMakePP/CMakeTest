include_guard()
include(cmake_test/detail_/parse_test)

set(_ct_internal_n_tests)
set(_ct_internal_test_names)
set(_ct_internal_n_sections)
set(_ct_internal_section_names)
set(_ct_internal_sections)
set(_ct_internal_asserts)
set(_ct_internal_assert_input)
set(_ct_binary_dir ${CMAKE_BINARY_DIR})

#FUNCTION
#
# This function uses reflection to add a unit test to the runner.
function(ct_add_test _ct_test_name)
    file(READ ${CMAKE_CURRENT_LIST_FILE} _at_contents)

    _ct_parse_test(_at_sections _at_code _at_asserts "${_at_contents}")

    message("Sections: ${_at_sections}")
    message("Contents: ${_at_code}")
    message("Asserts:  ${_at_asserts}")

    #Set the test name and initialize buffers
    set(_ct_internal_test_name "${_ct_test_name}" PARENT_SCOPE)
    set(_ct_internal_n_sections 0 PARENT_SCOPE)
    set(_ct_internal_section_names "" PARENT_SCOPE)
    set(_ct_internal_sections "" PARENT_SCOPE)
endfunction()
