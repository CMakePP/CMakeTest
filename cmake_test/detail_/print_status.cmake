include_guard()
include(cmake_test/detail_/utilities/repeat_string)

function(_ct_print_result _pr_name _pr_result _pr_depth)
    _ct_repeat_string(_pr_tab "    " ${_pr_depth})
    set(_pr_prefix "${_pr_tab}${_pr_name}")
    string(LENGTH "${_pr_prefix}${_pr_result}" _pr_n)
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
