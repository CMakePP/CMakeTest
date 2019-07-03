include_guard()
include(cmake_test/detail_/utilities) #For return
include(cmake_test/detail_/test_state/get_prop)

## @memberof TestState
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
#  @param[in] handle The handle to the TargetState object
#  @param[out] content An identifirer to hold the contents of the current test.
function(_ct_test_state_get_content _tsgc_handle _tsgc_content)
    cmake_policy(SET CMP0007 NEW)
    _ct_get_prop(_tsgc_test_content "${_tsgc_handle}" "test_content")

    list(LENGTH _tsgc_test_content _tsgc_length)
    set(_tsgc_counter 0)
    set(${_tsgc_content} "")
    while("${_tsgc_counter}" LESS "${_tsgc_length}")
        list(GET _tsgc_test_content ${_tsgc_counter} _tsgc_part)
        set(${_tsgc_content} "${${_tsgc_content}}\n${_tsgc_part}")
        math(EXPR _tsgc_counter "${_tsgc_counter} + 1")
    endwhile()
    _ct_return(${_tsgc_content})
endfunction()
