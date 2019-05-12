include_guard()
include(cmake_test/detail_/debug)
include(cmake_test/detail_/utilities)

function(_ct_handle_should_pass _hsp_result _hsp_handle)
    get_target_property(_hsp_sp_list ${_hsp_handle} CT_SHOULD_PASS)
    _ct_lc_find(_hsp_should_fail "FALSE" "${_hsp_sp_list}")

    _ct_result_debug("Should the test fail: ${_hsp_should_fail}")

    #Figure out if the test passed and whether it should have
    set(_hsp_passed TRUE)
    if("${_hsp_result}" STREQUAL "0") #Test passed
        if(_hsp_should_fail)
            set(_hsp_passed FALSE)
            set(_hsp_reason "Test passed (and it shouldn't).")
        endif()
    else() #Test failed
        if(NOT _hsp_should_fail)
            set(_hsp_passed FALSE)
            set(_hsp_reason "Test failed (and it shouldn't).")
        endif()
    endif()

    #Report failure
    if(NOT _hsp_passed)
        message(FATAL_ERROR "Test ${_hsp_name} FAILED because ${_hsp_reason}")
    endif()
endfunction()
