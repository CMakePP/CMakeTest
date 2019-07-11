include_guard()
include(cmake_test/detail_/test_section/test_section)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/lc_find)

## @fn _ct_parse_assert(handle, line)
#  @brief Parses an assert found in a unit test
#
#  This funciton is responsible for dispatching among the various types of
#  assertions. For the most part the assertions simply need to be dumped into
#  the contents of the unit test; however, there are a few assertions such as
#  "ct_assert_prints, which require different handeling. The logic for these
#  special asserts is encapsulated within this function.
#
#  @param[in] handle The handle to the TargetState object
#  @param[in] line The assertion line we found in the unit test
function(_ct_parse_assert _pa_handle _pa_line)
    _ct_is_handle(_pa_handle)
    _ct_nonempty_string(_pa_line)

    # See if this is one of the special assertions
    _ct_lc_find(_pa_is_print "ct_assert_prints" "${${_pa_line}}")
    _ct_lc_find(_pa_is_fail  "ct_assert_fails_as" "${${_pa_line}}")

    if(_pa_is_print)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pa_match "${${_pa_line}}")
        test_section(MUST_PRINT ${_pa_handle} "${CMAKE_MATCH_1}")
    elseif(_pa_is_fail)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pa_match "${${_pa_line}}")
        test_section(MUST_PRINT ${_pa_handle} ${CMAKE_MATCH_1})
        test_section(SHOULD_FAIL ${_pa_handle})
    else() # dispatch for all other assertions
        test_section(ADD_CONTENT ${_pa_handle} "${_pa_line}")
    endif()
endfunction()
