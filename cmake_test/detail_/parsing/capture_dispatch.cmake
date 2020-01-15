include_guard()
#[[[ Parses CMakeTest commands that require arguments to be captured.
#
# This function is responsible for dispatching among the various CMakeTest
# commands that require us to capture their arguments. If the line currently
# being parsed is not one of the commands that require capture this function
# does nothing. If the line is one of the commands this function will parse the
# line, updated/create the instance, and advance the buffers.
#
# :param _cd_contents: The text inside the unit test file currently being
#                      parsed.
# :type _cd_contents: [str]
# :param _cd_index: Which line number of the contents should this function be
#                   parsing?
# :type _cd_index: int
# :param _cd_identifier: The instance storing the contents of the unit test.
# :type _cd_identifier: TestSection
# :returns: All input quantities are also returned (and possibly updated).
#
# .. note:
#
#    This function is a macro as it is inteded to be used as a logical
#    factorization inside parse_dispatch and we don't want parse_dispatch
#    to have to act on the results of this function. Since it is a macro, if it
#    calls ``return()`` it actually will return from ``_ct_parse_dispatch()``
#
#]]
macro(_ct_capture_dispatch _cd_contents _cd_index _cd_identifier)
    set(_cd_handle "${${_cd_identifier}}")
    list(GET ${_cd_contents} ${${_cd_index}} _cd_line)
    _ct_lc_find(_cd_is_test "ct_add_test" "${_cd_line}")
    _ct_lc_find(_cd_is_section "ct_add_section" "${_cd_line}")
    _ct_lc_find(_cd_is_fail "ct_assert_fails_as" "${_cd_line}")
    _ct_lc_find(_cd_is_print "ct_assert_prints" "${_cd_line}")

    if(_cd_is_test OR _cd_is_section OR _cd_is_fail OR _cd_is_print)
        _ct_parse_ct_command(_cd_args ${_cd_index} ${_cd_contents})

        if(_cd_is_test) #Start of new test
            _ct_test_section(CTOR ${_cd_identifier} "${_cd_args}")
            _ct_return(${_cd_identifier})
        elseif(_cd_is_section) #Start of a section
            _ct_test_section(
                    ADD_SECTION ${_cd_handle} ${_cd_identifier} "${_cd_args}"
            )
            _ct_return(${_cd_identifier})
        elseif(_cd_is_print)
            _ct_test_section(MUST_PRINT ${_cd_handle} "${_cd_args}")
        elseif(_cd_is_fail)
            _ct_test_section(MUST_PRINT ${_cd_handle} "${_cd_args}")
            _ct_add_prop(${_cd_handle} "should_pass" FALSE)
        endif()

        _ct_return(${_cd_index})
        _ct_return(${_cd_contents})
        return()
    endif()
endmacro()      
