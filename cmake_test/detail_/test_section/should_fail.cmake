include_guard()

#[[[ Signals that the current section should fail.
#
# This function encapsulates the process of setting a section's state so that
# it fails.
#
# :param _tssf_handle: The TestSection instance which should fail
# :type _tssf_handle: TestSection
#]]
function(_ct_test_section_should_fail _tssf_handle)
    _ct_is_handle(_tssf_handle)

    _ct_add_prop(${_tssf_handle} "should_pass" FALSE)
endfunction()
