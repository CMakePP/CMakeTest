include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/parse_assert)
include(cmake_test/detail_/parse_test)
include(cmake_test/detail_/parse_section)
include(cmake_test/detail_/utilities)

function(_ct_parse_dispatch _pd_line _pd_prefix _pd_handle)
    _ct_parse_debug("Current line: ${_pd_line}")

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
    _ct_lc_find(_pd_is_assert "ct_assert" "${_pd_lc_line}")

    #Grab whatever's between the ()'s for add_test, add_section, and assert
    if(_pd_is_test OR _pd_is_section)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pd_match "${_pd_line}")
        set(_pd_args "${CMAKE_MATCH_1}")
        _ct_parse_debug("Args: ${_pd_args}")
    endif()

    if(_pd_is_test) #Start of new test
        _ct_start_test(${_pd_handle} "${_pd_args}")
    elseif(_pd_is_etest) #End of a test
        _ct_finish_test(${_pd_handle} "${_pd_prefix}")
    elseif(_pd_is_section) #Start of a section
        _ct_start_section(${_pd_handle} "${_pd_args}")
    elseif(_pd_is_esection) #End of a section
        _ct_finish_section(${_pd_handle} "${_pd_prefix}")
    elseif(_pd_is_assert) #Assert for this section
        _ct_parse_assert(${_pd_handle} "${_pd_lc_line}")
    elseif(_ct_in_test) #Just a line of code
        _ct_update_target("${_pd_handle}" CT_CONTENT "${_pd_line}")
    endif()
    _ct_print_target(${_pd_handle})
endfunction()
