include_guard()
include(cmake_test/detail_/test_section/make_flags)
include(cmake_test/detail_/test_section/test_prefix)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/print_result)

function(_ct_write_and_run_contents _warc_prefix _warc_handle)
    _ct_nonempty_string(_warc_prefix)
    _ct_is_handle(_warc_handle)

    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements

    # Assemble this tests's file path
    _ct_test_section_test_prefix(${_warc_handle} _warc_title)
    set(_warc_dir "${_warc_prefix}/${_warc_title}")
    set(_warc_file "${_warc_dir}/src/CMakeLists.txt")

    #The header common to each test
    set(_warc_header "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n")
    set(_warc_header "${_warc_header}project(${_warc_title} VERSION 0.0)\n")
    set(_warc_header "${_warc_header}include(cmake_test/asserts/asserts)\n")

    _ct_test_section(GET_CONTENT ${_warc_handle} _warc_content)
    file(WRITE ${_warc_file} "${_warc_header}${_warc_content}")

    #Run the test
    _ct_test_section_make_flags(${_warc_handle} _warc_flags ${_warc_dir})
    execute_process(
        COMMAND ${CMAKE_COMMAND} ${_warc_flags}
        RESULT_VARIABLE _warc_result
        OUTPUT_VARIABLE _warc_output
        ERROR_VARIABLE  _warc_errors
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    file(WRITE ${_warc_dir}/output_log.txt "${_warc_output}")
    file(WRITE ${_warc_dir}/error_log.txt  "${_warc_errors}")

    _ct_test_section(
        POST_TEST_ASSERTS ${_warc_handle}
                          "${_warc_result}"
                          "${_warc_output}\n${_warc_errors}"
    )
endfunction()
