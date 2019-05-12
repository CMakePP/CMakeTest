include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/write_and_run_contents)

function(_ct_start_test _st_handle _st_name)
    _ct_parse_debug("Parsing test ${_st_name}")

    _ct_update_target(${_st_handle} CT_TEST_NAME "${_st_name}")
    message("Starting Test: ${_st_name}")
endfunction()

function(_ct_finish_test _ft_handle)
    _ct_parse_debug("Finished parsing test.")
    _ct_write_and_run_contents("${_pd_prefix}" "${_ft_handle}")
    #TODO clean-up target's buffers
endfunction()
