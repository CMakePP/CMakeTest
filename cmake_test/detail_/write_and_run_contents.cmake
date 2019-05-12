include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/print_status)
include(cmake_test/detail_/should_pass)

function(_ct_make_test_flags _mtf_flags _mtf_sec_dir)
    list(APPEND ${_mtf_flags} "-H${_mtf_sec_dir}")
    list(APPEND ${_mtf_flags} "-B${_mtf_sec_dir}/build_dir")
    list(APPEND ${_mtf_flags} "-DCMAKE_INSTALL_PREFIX=${_mtf_sec_dir}/install")
    set(${_mtf_flags} "${${_mtf_flags}}" PARENT_SCOPE)
endfunction()

function(_ct_write_and_run_contents _warc_prefix _warc_handle)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    set(_warc_dir "${_warc_prefix}")
    set(_warc_file "${_warc_dir}/CMakeLists.txt")

   _ct_get_value(_warc_content_list ${_warc_handle} CT_CONTENT)
    foreach(_warc_content_i ${_warc_content_list})
        set(_warc_content "${_warc_content}${_warc_content_i}")
    endforeach()

    _ct_write_debug("Writing: ${_warc_content} to ${_warc_file}")

    list(GET _ct_test_name -1 _warc_name)


    #The header common to each test
    set(_warc_header "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n")
    set(_warc_header "${_warc_header}project(a_unit_test VERSION 0.0)\n")

    file(WRITE ${_warc_file} "${_warc_header}${_warc_content}")

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

    _ct_handle_should_pass("${_warc_result}" "${_warc_name}")

    set(_warc_passed TRUE)
    _ct_get_value(_warc_prints "${_warc_handle}" CT_PRINTS)
    #Note that CMake prints to standard error
    foreach(_warc_print ${_warc_prints})
        string(FIND "${_warc_errors}" "${_warc_print}" _warc_found)
        if("${_warc_found}" STREQUAL "-1")
            set(_warc_passed FALSE)
            set(_warc_reason "${_warc_print} was not found in ${_warc_errors}")
            break()
        endif()
    endforeach()


    if(NOT _warc_passed)
        _ct_print_result("${_warc_name}" "FAILED")
        message(FATAL_ERROR "Test ${_warc_name} FAILED because ${_warc_reason}")
    else()
        _ct_print_result("${_warc_name}" "PASSED")
    endif()
endfunction()
