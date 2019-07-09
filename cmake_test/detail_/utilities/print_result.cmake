include_guard()
include(cmake_test/detail_/utilities/repeat_string)

## @fn _ct_print_result(name, result, depth)
#  @brief Wraps the process of printing a test's result
#
#  This function largely serves as code factorization for print_pass and
#  print_fail. This function will print an indent appropriate for the current
#  nesting, and then enough dots to right align the result.
#
#  @param[in] name The test we are printing the result of.
#  @param[in] result Whether the test passed or failed
#  @param[in] depth How many sections is this test nested?
function(_ct_print_result _pr_name _pr_result _pr_depth)
    # Get the indent
    _ct_repeat_string(_pr_tab "    " ${_pr_depth})

    # This will be the LHS of the dots
    set(_pr_prefix "${_pr_tab}${_pr_name}")

    # This is how many characters our result takes up
    string(LENGTH "${_pr_prefix}${_pr_result}" _pr_n)

    # Get the number of dots to print
    set(_pr_width 80)
    set(_pr_n_dot 0)
    if("${_pr_n}" LESS ${_pr_width})
        math(EXPR _pr_n_dot "${_pr_width} - ${_pr_n}")
    endif()

    # Make the dots
    _ct_repeat_string(_pr_dots "." ${_pr_n_dot})

    # Finally print the result
    message("${_pr_prefix}${_pr_dots}${_pr_result}")
endfunction()

## @fn _ct_print_pass(name, depth)
#  @brief Wraps the process of printing that a test passed.
#
#  This function is called after all asserts on a test have been run. When
#  called this function will print to the standard output that the test ran
#  successfully.
#
#  @param[in] name The test we are printing the result of.
#  @param[in] depth How many sections is this test nested?
function(_ct_print_pass _pp_name _pp_depth)
    _ct_print_result(${_pp_name} "PASSED" ${_pp_depth})
endfunction()

## @fn _ct_print_fail(name, depth)
#  @brief Wraps the process of printing that a test failed.
#
#  This function is called after one or more asserts on a test have failed. When
#  called this function will print to the standard output that the test failed.
#  It will then print any additional content passed via `${ARGN}` assuming it is
#  the reason why the test failed. Finally, this function will issue a fatal
#  error stopping the test.
#
#  @param[in] name The test that just failed.
#  @param[in] depth How many sections is this test nested?
function(_ct_print_fail _pf_name _pf_depth)
    _ct_print_result(${_pf_name} "FAILED" ${_pf_depth})
    message(FATAL_ERROR "Reason:\n\n${ARGN}")
endfunction()
