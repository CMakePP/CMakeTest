include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/utilities)

## @fn _ct_parse_assert(handle, line)
#  @brief Parses an assert found in a unit test
#
#  This funciton is responsible for parsing an assert that we just came across
#  The list of currently recognized asserts are:
#
#  - ct_assert_prints : Asserts that the output contains the provided message
#  - ct_assert_equal : Asserts that the variable has the provided value
#  - ct_assert_not_equal : Asserts variable does not have specified value
#  - ct_assert_not_defined : Asserts that the variable is not defined
#
#  @param[in] handle The handle to the TargetState object
#  @param[out] content An identifirer to hold the contents of the current test.
function(_ct_parse_assert _pa_handle _pa_line)
    _ct_parse_debug("Assert: ${_pa_line}")
    _ct_lc_find(_pa_is_print "ct_assert_prints" "${_pa_line}")
    _ct_lc_find(_pa_is_equal "ct_assert_equal" "${_pa_line}")
    _ct_lc_find(_pa_is_ne    "ct_assert_not_equal" "${_pa_line}")
    _ct_lc_find(_pa_not_def  "ct_assert_not_defined" "${_pa_line}")
    if(_pa_is_print)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pa_match "${_pa_line}")
        test_state(MUST_PRINT ${_pa_handle} "${CMAKE_MATCH_1}")
    elseif(_pa_is_equal)
        message("Equal assert: ${_pa_line}")
    elseif(_pa_is_ne)
        message("Not equal assert: ${_pa_line}")
    elseif(_pa_not_def)
        message("Not defined: ${_pa_line}")
    else()
        message(FATAL_ERROR "Unrecognized assert")
    endif()
endfunction()
