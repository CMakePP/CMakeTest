include_guard()

function(_ct_lc_find _lf_found _lf_str _lf_line)
    string(FIND "${_lf_line}" "${_lf_str}" _lf_pos)
    set(${_lf_found} TRUE PARENT_SCOPE)
    if("${_lf_pos}" STREQUAL "-1")
        set(${_lf_found} FALSE PARENT_SCOPE)
    endif()
endfunction()

