include_guard()
include(cmake_test/detail_/parsing/parse_dispatch)
include(cmake_test/detail_/utilities/sanitize_name)


#[[[ Defines the top-level driver for CMakeTest.
#
# This function is the driver for unit testing. It will:
#
# - read-in the contents of the file it was called from
# - create a target to store the test information
# - parse the file
#]]
function(_ct_add_test_guts _atg_test_name)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    ############################################################################
    #                         Read in file contents                            #
    ############################################################################
    file(READ ${CMAKE_CURRENT_LIST_FILE} _atg_contents)
    string(REGEX REPLACE ";" "\\\\;" _atg_contents "${_atg_contents}")
    set(_atg_mangled_n "_ct_end_line_char_ct_")
    string(
        REGEX REPLACE "\\\\n"
                      "${_atg_mangled_n}"
                      _atg_contents
                      "${_atg_contents}"
    )
    string(REGEX REPLACE "\n" ";" _atg_contents "${_atg_contents}")
    string(
        REGEX REPLACE "${_atg_mangled_n}"
                      "\\\\n"
                      _atg_contents
                      "${_atg_contents}"
    )

    ############################################################################
    #                        Assemble paths for files                          #
    ############################################################################
    _ct_sanitize_name(_atg_test_name "${_atg_test_name}")
    string(RANDOM _atg_suffix)
    set(_atg_prefix ${CMAKE_BINARY_DIR}/${_atg_suffix})
    message("Files from this run are located in: ${_atg_prefix}")

    ############################################################################
    #                        Loop over file contents                           #
    ############################################################################
    list(LENGTH _atg_contents _atg_length) # Loop termination condition
    set(_atg_index 0) # The loop index
    set(_atg_handle "") # Our this pointer (currently NULL)
    while("${_atg_index}" LESS "${_atg_length}")
        #Parse the line, run tests we find
        _ct_parse_dispatch(_atg_contents _atg_index "${_atg_prefix}" _atg_handle)

        math(EXPR _atg_index "${_atg_index} + 1") #increment index
    endwhile()
endfunction()
