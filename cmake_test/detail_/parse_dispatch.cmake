include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/parse_assert)
include(cmake_test/detail_/write_and_run_contents)
include(cmake_test/detail_/test_state/test_state)

function(_ct_parse_dispatch _pd_line _pd_prefix _pd_identifier)
    #_ct_parse_debug("Current line: ${_pd_line}")

    #Check if it is a blank line, if it is return
    if(NOT _pd_line)
        return()
    endif()

    #Check if it is a comment, if it is return
    string(REGEX MATCH "\\s*#" _pd_match "${_pd_line}")
    if(_pd_match)
        return()
    endif()

    #See if it starts a block or is an assertion
    string(TOLOWER "${_pd_line}" _pd_lc_line)

    _ct_lc_find(_pd_is_test "ct_add_test" "${_pd_lc_line}")
    _ct_lc_find(_pd_is_etest "ct_end_test" "${_pd_lc_line}")

    _ct_lc_find(_pd_is_section "ct_add_section" "${_pd_lc_line}")
    _ct_lc_find(_pd_is_esection "ct_end_section" "${_pd_lc_line}")

    # All asserts start with "ct_assert"
    _ct_lc_find(_pd_is_assert "ct_assert" "${_pd_lc_line}")

    #Grab whatever's between the ()'s for add_test, add_section, and assert
    if(_pd_is_test OR _pd_is_section)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pd_match "${_pd_line}")
        set(_pd_args "${CMAKE_MATCH_1}")
    endif()

    # Get the handle the TestState identifier points to
    set(_pd_handle "${${_pd_identifier}}")

    if(_pd_is_test) #Start of new test
        test_state(CTOR ${_pd_identifier} "${_pd_args}")
        _ct_return(${_pd_identifier})
    elseif(_pd_is_etest) #End of a test
        _ct_write_and_run_contents("${_pd_prefix}" "${_pd_handle}")
        set(${_pd_identifier} "")
        _ct_return(${_pd_identifier})
    elseif(_pd_is_section) #Start of a section
        test_state(ADD_SECTION ${_pd_handle} "${_pd_args}")
    elseif(_pd_is_esection) #End of a section
        _ct_write_and_run_contents("${_pd_prefix}" "${_pd_handle}")
        test_state(END_SECTION ${_pd_handle})
    elseif(_pd_is_assert) #Assert for this section
        _ct_parse_assert(${_pd_handle} "${_pd_line}")
    else()
        if(NOT "${_pd_handle}" STREQUAL "") #Just a line of code in test
            _ct_parse_debug("Code: ${_pd_line}")
            test_state(ADD_CONTENT ${_pd_handle} "${_pd_line}")
        else()
            return() #Code outside test section
        endif()
    endif()
endfunction()
