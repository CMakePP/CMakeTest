include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/test_section/title)
include(cmake_test/detail_/utilities/print_result)

## @memberof TestSection
#  @public
#  @fn POST_TEST_ASSERTS(handle, result, output)
#  @brief Runs assertions that can only be performed after a test has completed.
#
#  After the literal contents of the CMakeLists.txt have been run there are
#  still asserts that need to be considered. That list presently includes:
#
#  1. Did the test run sucessfully (and was it supposed to)?
#  2. Did the correct output get printed?
#
#  @param[in] handle The TestSection instance with the test's state
#  @param[in] result The value returned from running the unit test
#  @param[in] output All output of running the test (standard out and errors
#                    concatentated together)
function(_ct_test_section_post_test_asserts _tspta_handle
                                            _tspta_result
                                            _tspta_output)

    _ct_is_handle(_tspta_handle)
    _ct_nonempty_string(_tspta_result)

    _ct_test_section_get_title("${_tspta_handle}" _tspta_name)
    _ct_test_section_depth(${_tspta_handle} _tspta_depth)

    # Should the test pass?
    _ct_test_section_should_pass("${_tspta_handle}" _tspta_should_pass)

    # Did the test pass?
    set(_tspta_did_pass FALSE)
    if("${_tspta_result}" STREQUAL "0")
        set(_tspta_did_pass TRUE)
    endif()

    # Error if test passed and it should not have
    if(_tspta_did_pass AND (NOT _tspta_should_pass))
        _ct_print_fail(
            ${_tspta_name}
            ${_tspta_depth}
            "Test passed and it should have failed"
        )
    endif()

    # Error if test failed and it should not have
    if((NOT _tspta_did_pass) AND _tspta_should_pass)
        _ct_print_fail(
            ${_tspta_name} ${_tspta_depth} "Output: ${_tspta_output}"
        )
    endif()

    # Ensure all messages printed
    _ct_get_prop("${_tspta_handle}" _tspta_prints  "print_assert")
    foreach(_tspta_print ${_tspta_prints})
        string(FIND "${_tspta_output}" "${_tspta_print}" _tspta_found)
        if("${_tspta_found}" STREQUAL "-1")
            _ct_print_fail(
                ${_tspta_name}
                ${_tspta_depth}
                "${_tspta_print} was not found in output. "
                "Output: ${_tspta_output}"
        )
        endif()
    endforeach()

    _ct_print_pass(${_tspta_name} ${_tspta_depth})
endfunction()
