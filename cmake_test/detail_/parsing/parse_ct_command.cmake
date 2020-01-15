include_guard()
include(cmake_test/detail_/utilities/lc_find)
include(cmake_test/detail_/utilities/return)

#[[[ Determines the argument to a CMakeTest command.
#
# Since we actually read the user's input script ahead of time and don't
# execute it, we need to ensure that we grab all of the arguments to it. Of
# particular note is when that command is spread across multiple lines.
#
# This function assumes that the current line starts a CMakeTest command, it
# does not check that this is the case. It also assumes that the opening
# parethesis appears on that line.
#
# .. todo::
#
#    This function currently only supports parsing a single-line CMakeTest
#    command. We need to be much more flexible.
#
# :param _pcc_result: An identifier to hold the argument that was provided to
#                     the CMakeTest command.
# :type _pcc_result: CMake identifier
# :param _pcc_index: The number of the line that we are parsing.
# :type _pcc_index: int
# :param _pcc_contents: The contents of the unit test we are parsing.
# :type _pcc_contents: [str]
# :returns: Upon returning ``${_pcc_result}`` will be the argument that was
#           passed to CMakeTest command.
#]]
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
