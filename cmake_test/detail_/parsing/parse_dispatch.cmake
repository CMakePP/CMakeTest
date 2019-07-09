include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/parsing/parse_assert)
include(cmake_test/detail_/write_and_run_contents)
include(cmake_test/detail_/test_section/test_section)
include(cmake_test/detail_/utilities/input_check)

function(_ct_parse_dispatch _pd_line _pd_prefix _pd_identifier)
    # line can be empty
    _ct_nonempty_string(_pd_prefix)
    _ct_nonempty_string(_pd_identifier)
    #_ct_parse_debug("Current line: ${_pd_line}")

    #Does it contain one of our commands

    # If yes, it's something like <command><ws>(<ws><stuff><ws>)
    # where <command> is the name of the command, <ws> is white space, and
    # <stuff> is what we care about (possibly with some whitespace in it too)
    # we thus need to keep reading lines until we find the opening and closing
    # parenthesis and have all of "stuff"
    #
    # For now we throw an error if everything's not on one line

    #If it doesn't contain our command check if it is a blank line
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
        test_section(CTOR ${_pd_identifier} "${_pd_args}")
        _ct_return(${_pd_identifier})
    elseif(_pd_is_etest) #End of a test
        _ct_write_and_run_contents("${_pd_prefix}" "${_pd_handle}")
        set(${_pd_identifier} "")
        _ct_return(${_pd_identifier})
    elseif(_pd_is_section) #Start of a section
        test_section(ADD_SECTION ${_pd_handle} ${_pd_identifier} "${_pd_args}")
        _ct_return(${_pd_identifier})
    elseif(_pd_is_esection) #End of a section
        _ct_write_and_run_contents("${_pd_prefix}" "${_pd_handle}")
        test_section(END_SECTION ${_pd_handle} ${_pd_identifier})
        _ct_return(${_pd_identifier})
    elseif(_pd_is_assert) #Assert for this section
        _ct_parse_assert(${_pd_handle} "${_pd_line}")
    else()
        if(NOT "${_pd_handle}" STREQUAL "") #Just a line of code in test
            test_section(ADD_CONTENT ${_pd_handle} "${_pd_line}")
        else()
            return() #Code outside test section
        endif()
    endif()
endfunction()
