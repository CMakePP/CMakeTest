include_guard()
include(cmake_test/detail_/utilities/repeat_string)

#[[[ Wraps the process of printing a test's result
#
#  This function largely serves as code factorization for ``_ct_print_pass`` and
#  ``_ct_print_fail``. This function will print an indent appropriate for the
#  current nesting, and then enough dots to right align the result.
#
#  :param _pr_name: The name of the test we are printing the result of.
#  :type _pr_name: str
#  :param _pr_result: What to print as the result (usually "PASSED" or "FAILED")
#  :type _pr_result: str
#  :param _pr_depth: How many sections is this test nested?
#  :type _pr_depth: str
#  :param _pr_print_length: The total length of the line to be printed, including dots and whitespace
#  :type _pr_print_length: int
#]]
function(_ct_print_result _pr_name _pr_result _pr_depth _pr_print_length)
    #message("Print length is: ${_pr_print_length}")

    if(NOT _pr_print_length GREATER 0)
        set(_pr_print_length 80)
    endif()

    # Get the indent
    _ct_repeat_string(_pr_tab "    " ${_pr_depth})

    # This will be the LHS of the dots
    set(_pr_prefix "${_pr_tab}${_pr_name}")

    #Ignore control characters for color reset, bold green, and bold red when calculating length
    set(_pr_visible_chars "${_pr_prefix}${_pr_result}")
    if(NOT WIN32 AND CMAKETEST_USE_COLORS)
        string(REPLACE "${CT_ColorReset}" "" _pr_visible_chars "${_pr_visible_chars}")
        string(REPLACE "${CT_BoldGreen}" "" _pr_visible_chars "${_pr_visible_chars}")
        string(REPLACE "${CT_BoldRed}" "" _pr_visible_chars "${_pr_visible_chars}")
    endif()
    # This is how many characters our result takes up
    string(LENGTH "${_pr_visible_chars}" _pr_n)

    # Get the number of dots to print
    set(_pr_width "${_pr_print_length}")
    set(_pr_n_dot 0)
    if("${_pr_n}" LESS ${_pr_width})
        math(EXPR _pr_n_dot "${_pr_width} - ${_pr_n}")
    endif()

    # Make the dots
    _ct_repeat_string(_pr_dots "." ${_pr_n_dot})

    # Finally print the result
    message("${_pr_prefix}${_pr_dots}${_pr_result}")
endfunction()

##[[[ Wraps the process of printing that a test passed.
#
# This function is called after all asserts on a test have been run. When
# called this function will print to the standard output that the test ran
# successfully.
#
# :param _pp_name: The test we are printing the result of.
# :type _pp_name: str
# :param _pp_depth: How many sections is this test nested?
# :type _pp_depth: str
#  :param _pp_print_length: The total length of the line to be printed, including dots and whitespace
#  :type _pp_print_length: int
#]]
function(_ct_print_pass _pp_name _pp_depth _pp_print_length)
    _ct_print_result(${_pp_name} "${CT_BoldGreen}PASSED${CT_ColorReset}" ${_pp_depth} "${_pp_print_length}")
endfunction()

#[[[ Wraps the process of printing that a test failed.
#
# This function is called after one or more asserts on a test have failed. When
# called this function will print to the standard output that the test failed.
# It will then print any additional content passed via `${ARGN}` assuming it is
# the reason why the test failed. Finally, this function will issue a fatal
# error stopping the test.
#
# :param _pf_name: The name of the test that just failed.
# :type _pf_name: str
# :param _pf_depth: How many sections is this test nested?
# :type _pf_depth: str
#  :param _pf_print_length: The total length of the line to be printed, including dots and whitespace
#  :type _pf_print_length: int
#]]
function(_ct_print_fail _pf_name _pf_depth _pf_print_length)
    _ct_print_result(${_pf_name} "${CT_BoldRed}FAILED${CT_ColorReset}" ${_pf_depth} "${_pf_print_length}")
    #message(FATAL_ERROR "Reason:\n\n${ARGN}")
endfunction()
