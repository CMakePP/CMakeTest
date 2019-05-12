include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/parse_dispatch)
include(cmake_test/detail_/utilities)

#FUNCTION
#
# This function is the driver for unit testing
function(_ct_add_test_guts _atg_test_name)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    _ct_parse_debug("Parsing: ${CMAKE_CURRENT_LIST_FILE}")

    #Read in the file to parse, protecting special characters
    file(READ ${CMAKE_CURRENT_LIST_FILE} _atg_contents)
    STRING(REGEX REPLACE ";" "\\\\;" _atg_contents "${_atg_contents}")
    STRING(REGEX REPLACE "\n" ";" _atg_contents "${_atg_contents}")

    #Get length (in lines) of the file and loop over them
    list(LENGTH _atg_contents _atg_length)
    set(_atg_index 0)

    #Make a target to hold the values
    string(RANDOM _atg_handle)

    _ct_sanitize_name(_atg_test_name "${_atg_test_name}")
    string(RANDOM _atg_suffix)
    set(_atg_prefix ${CMAKE_BINARY_DIR}/${_atg_test_name}/${_atg_suffix})
    message("Files from this run are located in: ${_atg_prefix}")

    while("${_atg_index}" LESS "${_atg_length}")
        list(GET _atg_contents ${_atg_index} _atg_line)
        _ct_parse_dispatch("${_atg_line}" "${_atg_prefix}" "${_atg_handle}")
        math(EXPR _atg_index "${_atg_index} + 1")
    endwhile()
endfunction()
