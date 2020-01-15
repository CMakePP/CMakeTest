include_guard()

#[[[ Returns (as a list) all of the CMakeTest commands that need to have their
#    arguments captured.
#
# This function encapsulates the logic required to retrieve a list of all
# CMakeTest commands that require us to capture their arguments while parsing.
#
# :param _cc_list: An identifier to hold the list of commands
# :returns: After this function ``${_cc_list}`` will contain a list of
#           CMakeTest commands that require their arguments to be
#           captured.
#]]
function(_ct_capture_commands _cc_list)
    set(
        ${_cc_list}
        "ct_add_test"
        "ct_add_section"
        "ct_assert_fails_as"
        "ct_assert_prints"
    )
    _ct_return(${_cc_list})
endfunction()
