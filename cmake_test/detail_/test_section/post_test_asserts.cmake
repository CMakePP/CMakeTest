include_guard()
include(cmake_test/detail_/print_status)
include(cmake_test/detail_/test_section/get_prop)
include(cmake_test/detail_/test_section/title)

function(_ct_fail_test _ft_handle)
    _ct_test_section_get_title("${_ft_handle}" _ft_name)
    _ct_test_section_depth(${_ft_handle} _ft_depth)
    _ct_print_result("${_ft_name}" "FAILED" "${_ft_depth}")
    message(FATAL_ERROR "Reason:\n\n${ARGN}")
endfunction()

## @memberof TestState
#  @public
#  @fn POST_TEST_ASSERTS(handle, result, output, errors)
#  @brief Runs assertions that can only be performed after a test has completed.
#
#  After the literal contents of the CMakeLists.txt have been run there are
#  still asserts that need to be considered. That list presently includes:
#
#  1. Did the test run sucessfully (and was it supposed to)?
#  2. Did the correct output get printed?
#
#  @param[in] handle The TestState instance with the test's state
#  @param[in] result The value returned from running the unit test
#  @param[in] output The standard output and errors concatenated together.
function(_ct_test_section_post_test_asserts _tspta_handle
                                            _tspta_result
                                            _tspta_output)

    _ct_test_section_get_title("${_tspta_handle}" _tspta_name)
    _ct_test_section_depth(${_tspta_handle} _tspta_depth)

    _ct_test_section_should_pass("${_tspta_handle}" _tspta_should_pass)

    # Did the test pass?
    set(_tspta_did_pass FALSE)
    if("${_tspta_result}" STREQUAL "0")
        set(_tspta_did_pass TRUE)
    endif()

    # Error if test passed and it should not have
    if(_tspta_did_pass AND (NOT _tspta_should_pass))
        _ct_fail_test(${_tspta_handle} "Test passed and it should have failed")
    endif()

    # Error if test failed and it should not have
    if((NOT _tspta_did_pass) AND _tspta_should_pass)
        _ct_fail_test(${_tspta_handle} "Output: ${_tspta_output}")
    endif()

    # Ensure all messages printed
    _ct_get_prop(_tspta_prints "${_tspta_handle}" "print_assert")
    foreach(_tspta_print ${_tspta_prints})
        string(FIND "${_tspta_output}" "${_tspta_print}" _tspta_found)
        if("${_tspta_found}" STREQUAL "-1")
            _ct_fail_test(
                ${_tspta_handle} "${_tspta_print} was not found in output"
        )
        endif()
    endforeach()

    _ct_print_result("${_tspta_name}" "PASSED" "${_tspta_depth}")
endfunction()
