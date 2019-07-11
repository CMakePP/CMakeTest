include_guard()

## @memberof TestSection
#  @fn SHOULD_FAIL(handle)
#  @brief Signals that the current section should fail
#
#  This function encapsulates the process of setting a section's state so that
#  it fails.
#
#  @param[in] handle The TestSection instance which should fail
function(_ct_test_section_should_fail _tssf_handle)
    _ct_is_handle(_tssf_handle)

    _ct_add_prop(${_tssf_handle} "should_pass" FALSE)
endfunction()
