include_guard()

#FUNCTION
#
# Function which prints its debug message only if CT_DEBUG_PARSE is true or if
# CT_DEBUG_ALL is true. This function is used to print debug information in
# routines that are responsible for parsing the unit test.
function(_ct_parse_debug)
    if(CT_DEBUG_PARSE OR CT_DEBUG_ALL)
        message("Parse Debug: ${ARGN}")
    endif()
endfunction()

#FUNCTION
#
# Prints its debug message only if CT_DEBUG_WRITE is trure or if CT_DEBUG_ALL is
# true This function is used in routines associated with writing the individual
# unit tests.
function(_ct_write_debug)
    if(CT_DEBUG_WRITE OR CT_DEBUG_ALL)
        message("Write Debug: ${ARGN}")
    endif()
endfunction()

#FUNCTION
#
# Prints its debug message only if CT_DEBUG_RESULT is true of if CT_DEBUG_ALL is
# true. This funciton is used in routines that process the results of a unit
# test.
function(_ct_result_debug)
    if(CT_DEBUG_RESULT OR CT_DEBUG_ALL)
        message("Result Debug: ${ARGN}")
    endif()
endfunction()
