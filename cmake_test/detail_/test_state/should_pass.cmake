include_guard()
include(cmake_test/detail_/test_state/get_prop)
include(cmake_test/detail_/utilities)

## @memberof TestState
#  @public
#  @fn SHOULD_PASS(handle, result)
#  @brief Returns whether the current test should pass or not.
#
#  An important part of unit testing is ensuring that code fails when it is
#  supposed to. For this reason the TestState class has an internal attribute
#  which keeps track of whether or not the test should fail. This function can
#  be used to retrieve whether it should or not.
#
#  @param[in] handle A TestState instance
#  @param[out] result An identifier to hold whether the test should fail.
function(_ct_test_state_should_pass _tssp_handle _tssp_result)
    _ct_get_prop(_tsac_sp ${_tssp_handle} "should_pass")
    list(GET _tsac_sp -1 ${_tssp_result})
    _ct_return(${_tssp_result})
endfunction()
