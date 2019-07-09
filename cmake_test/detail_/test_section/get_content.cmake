include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)
include(cmake_test/detail_/test_section/get_prop)

## @memberof TestSection
#  @public
#  @fn GET_CONTENT(handle, content)
#  @brief Returns the contents of the current test's section.
#
#  This function will return the contents of the CMakeLists.txt for the current
#  test section. The contents of the current section is obtained by
#  concatenating the contents encountered so far. For example given:
#
#  ```.cmake
#  ct_add_test("test name")
#  X
#      ct_section("section")
#      Y
#      ct_end_section()
#  ct_end_test()
#  ```
#  where `X` and `Y` are normal, native CMake content, this function would
#  return the string `"X\nY"`.
#
#  @param[in] handle The handle to the TestSection object
#  @param[out] content An identifirer to hold the contents of the current test.
function(_ct_test_section_get_content _tsgc_handle _tsgc_content)
    # Validate input
    _ct_is_handle(_tsgc_handle)
    _ct_nonempty_string(_tsgc_content)

    # Get our content and our parent
    cmake_policy(SET CMP0007 NEW) # Gets the content even if it's empty
    _ct_get_prop(_tsgc_test_content "${_tsgc_handle}" "content")
    _ct_get_prop(_tsgc_parent "${_tsgc_handle}" "parent_section")

    # Get parent section's content (if we have a parent)
    if(NOT "${_tsgc_parent}" STREQUAL "0")
        _ct_test_section_get_content("${_tsgc_parent}" ${_tsgc_content})
    endif()

    # Append our content and return
    set(${_tsgc_content} "${${_tsgc_content}}\n${_tsgc_test_content}")
    _ct_return(${_tsgc_content})
endfunction()
