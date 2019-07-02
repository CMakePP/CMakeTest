include_guard()
include(cmake_test/detail_/print_status)
include(cmake_test/detail_/test_state/get_prop)
include(cmake_test/detail_/test_state/title)

## @fn _ct_handle_should_pass(result, should_fail)
#  @brief Code factorization for determining if a test should fail or not
#
#  To clean-up the POST_TEST_ASSERTS call we have factored out the logic for
#  enusring that a test passed when it should have. This function only asserts
#  that the test passed when it should have (or failed when it should have), it
#  does not assert that the test failed for the correct reason (this is done by
#  POST_TEST_ASSERTS during the phase which looks for particular output).
#
#  @param[in] result The result of running the test.
#  @param[in] should_fail True if the test should have failed and false
#             otherwise.
function(_ct_handle_should_pass _hsp_name _hsp_result _hsp_should_fail)
    #Figure out if the test passed and whether it should have
    set(_hsp_passed TRUE)
    if("${_hsp_result}" STREQUAL "0") #Test passed
        if(_hsp_should_fail)
            set(_hsp_passed FALSE)
            set(_hsp_reason "the test passed (and it shouldn't have).")
        endif()
    else() #Test failed
        if(NOT _hsp_should_fail)
            set(_hsp_passed FALSE)
            set(_hsp_reason "the test failed (and it shouldn't have).")
        endif()
    endif()

    #Report failure
    if(NOT _hsp_passed)
        _ct_print_result("${_hsp_name}" "FAILED" "0")
        message(FATAL_ERROR "Test ${_hsp_name} FAILED because ${_hsp_reason}")
    endif()
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
#  @param[in] handle
function(_ct_test_state_post_test_asserts _tspta_handle
                                          _tspta_result
                                          _tspta_output
                                          _tspta_errors)

    set(_tspta_passed TRUE)
    _ct_test_state_get_title("${_tspta_handle}" _tspta_name)

    # Did the test pass and should it have
    _ct_test_state_should_pass("${_tspta_handle}" _tspta_should_pass)
    if(_tspta_should_pass)
        _ct_handle_should_pass("${_tspta_name}" "${_tspta_result}" FALSE)
    else()
        _ct_handle_should_pass("${_tspta_name}" "${_tspta_result}" TRUE)
    endif()

    _ct_get_prop(_tspta_prints "${_tspta_handle}" "print_assert")
    #Note that CMake prints to standard error
    foreach(_tspta_print ${_tspta_prints})
        string(FIND "${_tspta_errors}" "${_tspta_print}" _tspta_found)
        if("${_tspta_found}" STREQUAL "-1")
            set(_tspta_passed FALSE)
            set(
                _tspta_reason
                "${_tspta_print} was not found in ${_tspta_errors}"
            )
            break()
        endif()
    endforeach()

    if(NOT _tspta_passed)
        _ct_print_result("${_tspta_name}" "FAILED" "0")
        message(
           FATAL_ERROR "Test ${_tspta_name} FAILED because ${_tspta_reason}"
        )
    else()
        _ct_print_result("${_tspta_name}" "PASSED" "0")
    endif()
endfunction()
