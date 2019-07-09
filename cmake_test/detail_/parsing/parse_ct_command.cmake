include_guard()
include(cmake_test/detail_/utilities/lc_find)
include(cmake_test/detail_/utilities/return)

## @fn _ct_parse_ct_command(result, index, contents)
#  @brief Determines the argument to a CMakeTest command.
#
#  Since we actually read the user's input script ahead of time and don't
#  execute it, we need to ensure that we grab all of the arguments to it. Of
#  particular note is when that command is spread across multiple lines.
#
#  This function assumes that the current line starts a CMakeTest command, it
#  does not check that this is the case. It also assumes that the opening
#  parethesis appears on that line
function(_ct_parse_ct_command _pcc_result _pcc_index _pcc_contents)
    list(GET _pcc_contents ${_pcc_index} _pcc_line)

    # Handle case where closing parenthesis is also on this line
    _ct_lc_find(_pcc_has_rp ")" "${_pcc_contents}")
    if(_pcc_has_rp)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pcc_match "${_pcc_line}")
        set(${_pcc_result} "${CMAKE_MATCH_1}")
        _ct_return(${_pcc_result})
        return()
    endif()

    message(
        FATAL_ERROR
        "CMakeTest does not presently support capturing multiline arguments"
    )
endfunction()
