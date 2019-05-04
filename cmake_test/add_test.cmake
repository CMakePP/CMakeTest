include_guard()
set(_ct_internal_test_name)
set(_ct_internal_n_sections)
set(_ct_internal_section_names)
set(_ct_internal_sections)

#FUNCTION
#
#
function(ct_add_test _ct_test_name)
    #Error-checking
    if(NOT "${_ct_internal_test_name}" STREQUALS "")
        message(
            FATAL_ERROR
            "Test name already set. Did you forget to call end_test?"
        )
    endif()

    #Set the test name and initialize buffers
    set(_ct_internal_test_name "${_ct_test_name}" PARENT_SCOPE)
    set(_ct_internal_n_sections 0 PARENT_SCOPE)
    set(_ct_internal_section_names "" PARENT_SCOPE)
    set(_ct_internal_sections "" PARENT_SCOPE)
endfunction()
