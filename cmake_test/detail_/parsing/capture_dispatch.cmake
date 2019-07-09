include_guard()

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
            test_section(CTOR ${_cd_identifier} "${_cd_args}")
            _ct_return(${_cd_identifier})
        elseif(_cd_is_section) #Start of a section
            test_section(
                    ADD_SECTION ${_cd_handle} ${_cd_identifier} "${_cd_args}"
            )
            _ct_return(${_cd_identifier})
        elseif(_cd_is_print)
            test_section(MUST_PRINT ${_cd_handle} "${_cd_args}")
        elseif(_cd_is_fail)
            test_section(MUST_PRINT ${_cd_handle} "${_cd_args}")
            _ct_add_prop(${_cd_handle} "should_pass" FALSE)
        endif()

        _ct_return(${_cd_index})
        _ct_return(${_cd_contents})
        return()
    endif()
endmacro()      
