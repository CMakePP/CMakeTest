include_guard()
include(cmake_test/detail_/debug)

function(_ct_make_test_flags _mtf_flags _mtf_sec_dir)
    list(APPEND ${_mtf_flags} "-H${_mtf_sec_dir}")
    list(APPEND ${_mtf_flags} "-B${_mtf_sec_dir}/build_dir")
    list(APPEND ${_mtf_flags} "-DCMAKE_INSTALL_PREFIX=${_mtf_sec_dir}/install")
    set(${_mtf_flags} "${${_mtf_flags}}" PARENT_SCOPE)
endfunction()

function(_ct_write_and_run_contents _warc_prefix _warc_contents)
    set(_warc_dir "${_warc_prefix}/${_ct_section}")
    set(_warc_file "${_warc_dir}/CMakeLists.txt")
    _ct_write_debug("Writing: ${_warc_contents} to ${_warc_file}")

    #The header common to each test
    set(_warc_header "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n")
    set(_warc_header "${_warc_header}project(a_unit_test VERSION 0.0)\n")

    file(WRITE ${_warc_file} "${_warc_header}${_warc_contents}")

    #Run the test
    _ct_make_test_flags(_warc_flags ${_warc_dir})
    execute_process(
        COMMAND ${CMAKE_COMMAND} ${_warc_flags}
        RESULT_VARIABLE _warc_result
        OUTPUT_VARIABLE _warc_output
        ERROR_VARIABLE  _warc_errors
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    _ct_result_debug("Result: ${_warc_result}")
    _ct_result_debug("Error : ${_warc_errors}")
    _ct_result_debug("Output: ${_warc_output}")
    set(_warc_should_pass TRUE)
    foreach(_warc_i ${_ct_should_pass})
        if(NOT _warc_i)
            set(_warc_should_pass FALSE)
            break()
        endif()
    endforeach()
    set(_warc_passed TRUE)
    if(NOT "${_warc_result}" STREQUAL "0")
        if(NOT _warc_should_pass)
            set(_warc_passed FALSE)
            set(_warc_reason "Test passed (and it shouldn't).")
        endif()
    else()
        if(_warc_should_pass)
            set(_warc_passed FALSE)
            set(_warc_reason "Test failed (and it shouldn't).")
        endif()
    endif()

    if(NOT _warc_passed)
        message(
            FATAL_ERROR "Test ${_ct_test_name} FAILED because ${_ct_reason}"
        )
    endif()

    foreach(_warc_print ${_ct_prints})
        string(FIND "${_warc_output}" "${_warc_print}" _warc_found)
        if("${_warc_found}" STREQUAL "-1")
            set(_warc_passed FALSE)
            set(_warc_reason "${_warc_print} was not found in ${_warc_outptu}")
            break()
        endif()
    endforeach()

    _ct_result_debug("Test ${_ct_test_name} passed: ${_warc_passed}")

endfunction()
