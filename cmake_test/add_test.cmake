include_guard()
include(cmake_test/detail_/parse_test)

function(_ct_parse_test _pt_new_idx _pt_old_idx _pt_contents)
    #REGEX to get test's name
    list(LENGTH ${_pt_contents} _pt_n)
    math(EXPR _pt_old_idx "${_pt_old_idx} + 1")
    while("${_pt_old_idx}" LESS "${_pt_n}")
        #See if this is a known section
        _ct_parse_dispatch(_pt_old_idx ${_pt_old_idx} ${_pt_contents})

    endwhile()

    #Read until we find end_test
    #Return line of end_test + 1
endfunction()

function(_ct_parse_section _ps_new_idx _ps_old_idx _ps_contents)
    #Read until we find end_section
    #Return line of end_section + 1
endfunction()

function(_ct_parse_assert _pa_new_idx _pa_old_idx _pa_contents)
    #Dispatch among asserts

    #Forward result
    set(${_pa_new_idx} ${${_pa_new_idx}} PARENT_SCOPE)
endfunction()

function(_ct_parse_dispatch _pd_new_idx _pd_old_idx _pd_contents)
    cmake_policy(SET CMP0007 NEW)
    list(GET _pd_contents ${_pd_old_idx} _pd_line)
    string(TOLOWER "${_pd_line}" "${_pd_lc_line}")

    string(FIND "${_pd_lc_line}" "ct_add_test" _pd_is_test)
    string(FIND "${_pd_lc_line}" "ct_add_section" _pd_is_section)
    string(FIND "${_pd_lc_line}" "ct_assert" _pd_is_assert)

    if(NOT "${_pd_is_test}" STREQUAL "-1")
        _ct_parse_test(${_pd_new_idx} ${_pd_old_idx} ${_pd_contents})
    elseif(NOT "${_pd_is_section}" STREQUAL "-1")
        _ct_parse_section(${_pd_new_idx} ${_pd_old_idx} ${_pd_contents})
    elseif(NOT "${_pd_is_assert}" STREQUAL "-1")
        _ct_parse_assert(${_pd_new_idx} ${_pd_old_idx} ${_pd_contents})
    else()
        set(${_pd_new_idx} ${_pd_old_idx})
    endif()
    set(${_pd_new_idx} ${${_pd_new_idx}} PARENT_SCOPE)
endfunction()


#FUNCTION
#
# This function uses reflection to add a unit test to the runner.
function(ct_add_test _at_test_name)

    if(_ct_file_parsed)
        return()
    endif()
    message("${CMAKE_CURRENT_LIST_FILE}")
    #Read in the file to parse, protecting special characters
    file(READ ${CMAKE_CURRENT_LIST_FILE} _at_contents)
    STRING(REGEX REPLACE ";" "\\\\;" _at_contents "${_at_contents}")
    STRING(REGEX REPLACE "\n" ";" _at_contents "${_at_contents}")

    #Get length (in lines) of file and loop over them
    list(LENGTH _at_contents _at_length)
    set(_at_index 0)

    while("${_at_index}" LESS "${_at_length}")
        _ct_parse_dispatch(_at_index ${_at_index} _at_contents)
        message("${_at_line}")
        math(EXPR _at_index "${_at_index} +1")
    endwhile()


    set(_ct_file_parsed TRUE PARENT_SCOPE)
endfunction()
