include_guard()

function(_ct_sanitize_name _sn_new_name _sn_old_name)
    string(TOLOWER "${_sn_old_name}" _sn_old_name)
    string(REPLACE " " "_" ${_sn_new_name} "${_sn_old_name}")
    set(${_sn_new_name} "${${_sn_new_name}}" PARENT_SCOPE)
endfunction()


function(_ct_make_test_flags _mtf_flags _mtf_sec_dir)
    list(APPEND ${_mtf_flags} "-H${_mtf_sec_dir}")
    list(APPEND ${_mtf_flags} "-B${_mtf_sec_dir}/build_dir")
    list(APPEND ${_mtf_flags} "-DCMAKE_INSTALL_PREFIX=${_mtf_sec_dir}/install")
    set(${_mtf_flags} "${${_mtf_flags}}" PARENT_SCOPE)
endfunction()

#FUNCTION
#
#
function(ct_end_test)
    return()
    #Error-checking
    if("${_ct_internal_test_name}" STREQUAL "")
        message(FATAL_ERROR "No test detected. Did you call add_test?")
    endif()
    if("${_ct_internal_n_sections}" STREQUAL "0")
        message(
            FATAL_ERROR "No test sections detected. Did you call add_section?"
        )
    endif()

    #Sanitize the test's name
    _ct_sanitize_name(_et_clean_name "${_ct_internal_test_name}")

    #The directory where this test's files will go
    set(_et_test_dir ${_ct_binary_dir}/${_et_clean_name})

    #The header common to each test
    set(_et_header "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n")
    set(_et_header "${_et_header}project(a_unit_test VERSION 0.0)\n")



    #CMake's foreach is stupid and includes the endpoint...
    math(EXPR _et_end "${_ct_internal_n_sections} - 1")
    #Loop over each section
    foreach(_et_i RANGE ${_et_end})
        #Make a directory for this running this section's files
        list(GET _ct_internal_section_names ${_et_i} _et_sec_name)
        string(RANDOM _et_random)
        _ct_sanitize_name(_et_clean_sec "${_et_sec_name}")
        set(_et_section_dir "${_et_test_dir}/${_et_clean_sec}/${_et_random}")
        message("Section: ${_et_sec_name}.\n    Files: ${_et_section_dir}")

        #Write the CMakeLists.txt with the test's contents
        list(GET _ct_internal_sections ${_et_i} _et_sec_contents)
        set(_et_sec_contents "${_et_header}${_et_sec_contents}")
        set(_et_test_file "${_et_section_dir}/CMakeLists.txt")
        file(WRITE ${_et_test_file} "${_et_sec_contents}")


        #Run the test
        _ct_make_test_flags(_et_flags ${_et_section_dir})
        execute_process(
            COMMAND ${CMAKE_COMMAND} ${_et_flags}
            RESULT_VARIABLE _et_section_result
            OUTPUT_VARIABLE _et_section_output
            ERROR_VARIABLE  _et_section_errors
            OUTPUT_STRIP_TRAILING_WHITESPACE
            ERROR_STRIP_TRAILING_WHITESPACE
        )
        message("    Result: ${_et_section_result}")
        message("    Error : ${_et_section_errors}")
        message("    Output: ${_et_section_output}")
    endforeach()
endfunction()
