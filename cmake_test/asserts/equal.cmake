include_guard()

function(ct_assert_equal _ae_lhs _ae_rhs)
    if(NOT "${${_ae_lhs}}" STREQUAL "${_ae_rhs}")
        message(
            FATAL_ERROR
            "Assertion: \"${_ae_lhs}\" == \"${_ae_rhs}\" failed. ${_ae_lhs} "
            "contents: ${${_ae_lhs}}"
        )
    endif()
endfunction()

function(ct_assert_not_equal _ane_lhs _ane_rhs)
    if("${${_ane_lhs}}" STREQUAL "${_ane_rhs}")
        message(
            FATAL_ERROR
           "Assertion: \"${_ane_lhs}\" != \"${_ane_rhs}\" failed. ${_ane_lhs} "
           "contents: ${${_ane_lhs}}"
        )
    endif()
endfunction()
