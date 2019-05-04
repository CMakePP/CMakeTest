include_guard()

#FUNCTION
#
#
function(ct_add_section _as_sec_name)
    #Error-checking
    if("${_ct_internal_test_name}" STREQUALS "")
        message(FATAL_ERROR "Test name not detected. Did you call add_test?")
    endif()
    if("${_as_sec_name}" STREQUALS "")
        message(FATAL_ERROR "Section name can not be empty.")
    endif()

    #Add the section's name and contents to our lists
    list(APPEND _ct_internal_section_names "${_as_sec_name}")
    list(APPEND _ct_internal_sections "${ARGN}")

    #Update the number of sections
    math(EXPR _as_buffer "${_ct_internal_n_sections} + 1")
    set(_ct_internal_n_sections ${_as_buffer} PARENT_SCOPE)
endfunction()
