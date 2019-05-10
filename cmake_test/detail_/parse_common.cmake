include_guard()

#FUNCTION
#
#
function(_ct_parse_debug)
    if(NOT _ct_debug_parse)
        return()
    endif()
    foreach(_pd_msg ${ARGN})
        message("${_pd_msg}")
    endforeach()
endfunction()

#If true debug printing for parsing will be enabled
set(_ct_parse_do_debug TRUE)
#The regex for finding add_test
set(_ct_parse_add_test "ct_add_test")
#The regex for finding add_section
set(_ct_parse_add_sec  "ct_add_section")
#The regex for finding
