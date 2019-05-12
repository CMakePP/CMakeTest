include_guard()

function(_ct_get_tab _gt_tab _gt_n_tabs)
    set(${_gt_tab} "")
    if("${_gt_n_tabs}" STREQUAL "0")
        set(${_gt_tab} "" PARENT_SCOPE)
        return()
    endif()

    #Account for range being inclusive
    math(EXPR _gt_n_tabs "${_gt_n_tabs} - 1")
    foreach(_gt_depth_i RANGE ${_gt_n_tabs})
        set(${_gt_tab} "${${gt_tab}}    ")
    endforeach()
    set(${_gt_tab} "${${_gt_tab}}" PARENT_SCOPE)
endfunction()

function(_ct_print_status _ps_msg)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements
    list(LENGTH _ct_test_name _ps_depth)
    math(EXPR _ps_depth "${_ps_depth} - 1")
    _ct_get_tab(_ps_tab "${_ps_depth}")
    message("${_ps_tab}${_ps_msg}")
endfunction()

function(_ct_print_result _pr_name _pr_result)
    list(LENGTH _ct_test_name _pr_depth)
    math(EXPR _pr_depth "${_pr_depth} - 1")
    _ct_get_tab(_pr_tab "${_pr_depth}")
    set(_pr_prefix "${_pr_tab}${_pr_name}")
    string(LENGTH "${_pr_prefx}${_pr_result}" _pr_n)
    set(_pr_n_dot 0)

    #CMake's ranges are inclusive so premptively subtract 1
    if("${_pr_n}" LESS 79)
        math(EXPR _pr_n_dot "79 - ${_pr_n}")
    endif()

    set(_pr_dots "")
    foreach(_pr_i RANGE ${_pr_n_dot})
        set(_pr_dots "${_pr_dots}.")
    endforeach()

    message("${_pr_prefix}${_pr_dots}${_pr_result}")
endfunction()
