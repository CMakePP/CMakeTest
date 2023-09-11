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

include_guard()

#[[[
# Asserts that an identifier contains a string
#
# For our purposes a string is anything that is not a list (a list being a
# string that contains at least one unescaped semicolon). This function will
# raise an error if the provided identifier is not a string. Consequentially,
# this function is more-or-less equivalent to ct_assert_not_list.
#
# .. note::
#    Be careful not to confuse this assertion with
#    testing for the :code:`str` CMakePPLang type.
#    This assertion only tests that the given variable
#    is not a list.
#
# :param var: The identifier we want the stringy-ness of.
# :type var: desc*
#]]
function(ct_assert_string _as_var)
    # Can't use cpp_assert_signature because of lists

    list(LENGTH ${_as_var} _as_length)
    if("${_as_length}" GREATER 1)
        cpp_raise(ASSERTION_FAILED "${_as_var} is list: ${${_as_var}}")
    endif()
endfunction()

#[[[
# Asserts that an identifier does not contain a string
#
# For our purposes a string is anything that is not a list (a list being a
# string that contains at least one unescaped semicolon). This function will
# raise an error if the provided identifier is a string. Consequentially, this
# function is more-or-less equivalent to ct_assert_list.
#
# :param var: The identifier we want the stringy-ness of.
# :type var: desc*
#]]
function(ct_assert_not_string _ans_var)
    # Can't use cpp_assert_signature because of lists

    list(LENGTH ${_ans_var} _ans_length)
    if("${_ans_length}" LESS 2)
        cpp_raise(ASSERTION_FAILED "${_ans_var} is string: ${${_ans_var}}")
    endif()
endfunction()
