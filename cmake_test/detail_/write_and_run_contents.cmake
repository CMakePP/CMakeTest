include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/print_status)
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_section/test_section)

function(_ct_make_test_flags _mtf_flags _mtf_sec_dir)
    get_filename_component(_mtf_pfx ${_CT_CMAKE_TEST_ROOT} DIRECTORY)
    list(APPEND ${_mtf_flags} "-H${_mtf_sec_dir}")
    list(APPEND ${_mtf_flags} "-B${_mtf_sec_dir}/build_dir")
    list(APPEND ${_mtf_flags} "-DCMAKE_INSTALL_PREFIX=${_mtf_sec_dir}/install")
    list(APPEND ${_mtf_flags} "-DCMAKE_MODULE_PATH=${_mtf_pfx}")
    set(${_mtf_flags} "${${_mtf_flags}}" PARENT_SCOPE)
endfunction()

function(_ct_write_and_run_contents _warc_prefix _warc_handle)
    _ct_nonempty_string(_warc_prefix)
    _ct_is_handle(_warc_handle)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements
    test_section(GET_CONTENT ${_warc_handle} _warc_content)

    # Assemble this tests's file path
    test_section(TITLE ${_warc_handle} _warc_title)
    _ct_sanitize_name(_warc_title "${_warc_title}")
    set(_warc_dir "${_warc_prefix}/${_warc_title}")
    set(_warc_file "${_warc_dir}/CMakeLists.txt")


    _ct_write_debug("Writing: ${_warc_content} to ${_warc_file}")

    #The header common to each test
    set(_warc_header "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n")
    set(_warc_header "${_warc_header}project(${_warc_title} VERSION 0.0)\n")
    set(_warc_header "${_warc_header}include(cmake_test/asserts/asserts)\n")

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

    test_section(
        POST_TEST_ASSERTS ${_warc_handle}
                          "${_warc_result}"
                          "${_warc_output}\n${_warc_errors}"
    )
endfunction()
