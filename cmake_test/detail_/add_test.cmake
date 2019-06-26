include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/parse_dispatch)
include(cmake_test/detail_/utilities)

#FUNCTION
#
# This function is the driver for unit testing. It will:
#
# - read-in the contents of the file it was called from
# - create a target to store the test information
# -
function(_ct_add_test_guts _atg_test_name)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    _ct_test_state_ctor(_atg_handle "${_atg_test_name}")

    ############################################################################
    #                         Read in file contents                            #
    ############################################################################
    _ct_parse_debug("Parsing: ${CMAKE_CURRENT_LIST_FILE}")
    file(READ ${CMAKE_CURRENT_LIST_FILE} _atg_contents)
    STRING(REGEX REPLACE ";" "\\\\;" _atg_contents "${_atg_contents}")
    STRING(REGEX REPLACE "\n" ";" _atg_contents "${_atg_contents}")



    ############################################################################
    #                        Assemble paths for files                          #
    ############################################################################
    _ct_sanitize_name(_atg_test_name "${_atg_test_name}")
    string(RANDOM _atg_suffix)
    set(_atg_prefix ${CMAKE_BINARY_DIR}/${_atg_test_name}/${_atg_suffix})
    message("Files from this run are located in: ${_atg_prefix}")

    ############################################################################
    #                        Loop over file contents                           #
    ############################################################################
    list(LENGTH _atg_contents _atg_length) # Loop termination condition
    set(_atg_index 0) # The loop index
    while("${_atg_index}" LESS "${_atg_length}")
        list(GET _atg_contents ${_atg_index} _atg_line) # Read current line

        #Parse the line, run tests we find
        _ct_parse_dispatch("${_atg_line}" "${_atg_prefix}" "${_atg_handle}")

        math(EXPR _atg_index "${_atg_index} + 1") #increment index
    endwhile()
endfunction()
