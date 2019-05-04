include_guard()

#FUNCTION
#
#
function(ct_end_test)
    if("${_ct_internal_test_name}" STREQUALS "")
        message(FATAL_ERROR "No test detected. Did you call add_test?")
    endif()

    foreach(_et_i RANGE ${_ct_internal_n_sections})
        list(GET _ct_internal_section_names ${_et_i} _et_sec_name)
        list(GET _ct_internal_sections ${_et_i} _et_sec_contents)
        message("Section: ${_et_sec_name}")
        message("Contents: ${_et_sec_contents}")
    endforeach()
endfunction()
