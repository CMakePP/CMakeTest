include_guard()
include(cmake_test/detail_/debug)

macro(_ct_start_section _ss_name)
    _ct_parse_debug("Parsing section: ${_ss_name} Depth: ${_ct_sec_depth}")
    #Error checking
    if(NOT _ct_in_test)
        message(FATAL_ERROR "ct_add_section called from outside ct_add_test")
    endif()
    _ct_recurse_buffers()
endmacro()

macro(_ct_end_section)
    _ct_parse_debug("Finished section at depth ${_ct_sec_depth}")
    _ct_pop_buffers()
endmacro()
