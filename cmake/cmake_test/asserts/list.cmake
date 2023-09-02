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
# Asserts that an identifier contains a list.
#
# For our purposes a list is defined as a string that contains one or more,
# unescaped semicolons. While a string with no semicolons is usable as if it is
# a single element list (or a zero element list if it is the empty string) this
# function will not consider such strings lists. If the identifier is not a list
# an error will be raised.
#
# :param var: The identifier we want to know the list-ness of.
# :type var: list*
#]]
function(ct_assert_list _al_var)
    list(LENGTH ${_al_var} _al_length)
    if("${_al_length}" LESS 2)
        cpp_raise(
            ASSERTION_FAILED
            "${_al_var} is not a list. Contents: ${${_al_var}}"
        )
    endif()
endfunction()

#[[[
# Asserts that an identifier does not contain a list.
#
# For our purposes a list is defined as a string that contains one or more,
# unescaped semicolons. While a string with no semicolons is usable as if it is
# a single element list (or a zero element list if it is the empty string) this
# function will not consider such strings lists. If the provided string is a
# list this function will raise an error.
#
# :param var: The identifier we want to know the list-ness of.
# :type var: list*
#]]
function(ct_assert_not_list _anl_var)
    list(LENGTH ${_anl_var} _anl_length)
    if("${_anl_length}" GREATER 1)
        cpp_raise(ASSERTION_FAILED "${_anl_var} is list: ${${_anl_var}}")
    endif()
endfunction()
