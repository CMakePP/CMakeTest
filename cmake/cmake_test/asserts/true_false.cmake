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
# Asserts that the provided variable is true.
# :code:`var` must be a non-empty string,
# otherwise an :code:`ASSERTION_FAILED`
# exception is raised.
#
# :param var: The variable to check for truthiness.
# :type var: str*
#]]
function(ct_assert_true _at_var)
    cpp_assert_signature("${ARGV}" str*)

    # Check separately for empty string
    # since it will blow up the next if statement
    # otherwise
    if (_at_var STREQUAL "")
        cpp_raise(
            ASSERTION_FAILED
            "ct_assert_true() given empty string as parameter"
        )
    endif()
    # Unquoted because quoted strings are always false
    # unless they are a true constant.
    if(NOT ${_at_var})
        cpp_raise(
            ASSERTION_FAILED
            "${_at_var} is not true."
        )
    endif()
endfunction()

#[[[
# Asserts that the provided variable is false.
#
# :param var: The variable to check for falseness.
# :type var: str*
#]]
function(ct_assert_false _af_var)
    cpp_assert_signature("${ARGV}" str*)

    # Check separately for empty string
    # since it will blow up the next if statement
    # otherwise
    if (_at_var STREQUAL "")
        cpp_raise(
            ASSERTION_FAILED
            "ct_assert_true() given empty string as parameter"
        )
    endif()

    # Unquoted because quoted strings are always false
    # unless they are a true constant
    if(${_af_var})
        cpp_raise(
            ASSERTION_FAILED
            "${_af_var} is not false."
        )
    endif()
endfunction()
