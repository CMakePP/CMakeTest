# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#[[[ @module
# This module contains all of the printing functions for CMakeTest
# to report the pass or fail status of a test or section.
#
# .. attention::
#    This module is intended for internal
#    use only.
#
#]]

include_guard()
include(cmake_test/detail_/utilities/repeat_string)

#[[[
# The print length used for the pass or fail lines, in characters.
#]]
set(CT_PRINT_LENGTH 80 CACHE STRING
    "The print length used for the CMakeTest pass or fail status lines. Must be an integer."
)


#[[[
# Wraps the process of printing a test's result
#
# This function largely serves as code factorization for ``_ct_print_pass`` and
# ``_ct_print_fail``. This function will print an indent appropriate for the
# current nesting, and then enough dots to right align the result.
#
# :param name: The name of the test we are printing the result of.
# :type name: desc
# :param result: What to print as the result (usually "PASSED" or "FAILED")
# :type result: desc
# :param depth: How many sections is this test nested?
# :type depth: int
# :param print_length: The total length of the line to be printed, including dots and whitespace
# :type print_length: int
#]]
function(_ct_print_result _pr_name _pr_result _pr_depth _pr_print_length)
    # Can't use assert_signature because the _pr_result may include
    # color codes, which can have semicolons in them and the signature assertion
    # interprets those as list delimiters

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
    if(_pr_n LESS _pr_width)
        math(EXPR _pr_n_dot "${_pr_width} - ${_pr_n}")
    endif()

    # Make the dots
    _ct_repeat_string(_pr_dots "." ${_pr_n_dot})

    # Finally print the result
    message("${_pr_prefix}${_pr_dots}${_pr_result}")
endfunction()

##[[[
# Wraps the process of printing that a test passed.
#
# This function is called after all asserts on a test have been run. When
# called this function will print to the standard output that the test ran
# successfully.
#
# :param name: The test we are printing the result of.
# :type name: desc
# :param depth: How many sections is this test nested?
# :type depth: int
# :param print_length: The total length of the line to be printed, including dots and whitespace
# :type print_length: int
#]]
function(_ct_print_pass _pp_name _pp_depth _pp_print_length)
    cpp_assert_signature("${ARGV}" str int int)
    _ct_print_result("${_pp_name}" "${CT_BoldGreen}PASSED${CT_ColorReset}" "${_pp_depth}" "${_pp_print_length}")
endfunction()

#[[[
# Wraps the process of printing that a test failed.
#
# This function is called after one or more asserts on a test have failed. When
# called this function will print to the standard output that the test failed.
# It will then print any additional content passed via `${ARGN}` assuming it is
# the reason why the test failed. Finally, this function will issue a fatal
# error stopping the test.
#
# :param name: The name of the test that just failed.
# :type name: desc
# :param depth: How many sections is this test nested?
# :type depth: int
# :param print_length: The total length of the line to be printed, including dots and whitespace
# :type print_length: int
#]]
function(_ct_print_fail _pf_name _pf_depth _pf_print_length)
    cpp_assert_signature("${ARGV}" str int int)
    _ct_print_result("${_pf_name}" "${CT_BoldRed}FAILED${CT_ColorReset}" "${_pf_depth}" "${_pf_print_length}")
endfunction()
