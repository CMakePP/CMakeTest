# Copyright 2025 CMakePP
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
include("cmakepp_lang/asserts/signature")

#[[[
# Asserts that the contents of the provided variable matches the given regular 
# expression.
#
# :code:`var` must be a non-empty string, otherwise an :code:`ASSERTION_FAILED`
# exception is raised.
#
# :param var: The variable to apply the RegEx to.
# :type var: str*
# :param regex: The RegEx to apply to var.
# :type regex: str
#]]
function(ct_assert_regex_equal _are_var _are_regex)
    cpp_assert_signature("${ARGV}" str* str)

    # Check separately for empty string
    # since it will blow up the next if statement
    # otherwise
    if (_are_var STREQUAL "")
        cpp_raise(
            ASSERTION_FAILED
            "ct_assert_regex_equal() given empty string as parameter"
        )
    endif()

    if(NOT (${_are_var} MATCHES "${_are_regex}"))
        cpp_raise(
            ASSERTION_FAILED
            "${_are_var} does not match RegEx ${_are_regex}."
        )
    endif()
endfunction()

#[[[
# Asserts that the contents of the provided variable don't match the given 
# regular expression.
#
# :param var: The variable to apply the regex to.
# :type var: str*
# :param regex: The regex to apply.
# :type regex: str
#]]
function(ct_assert_regex_not_equal _arne_var _arne_regex)
    cpp_assert_signature("${ARGV}" str* str)

    # Check separately for empty string
    # since it will blow up the next if statement
    # otherwise
    if (_arne_var STREQUAL "")
        cpp_raise(
            ASSERTION_FAILED
            "ct_assert_regex_not_equal() given empty string as parameter"
        )
    endif()

    if(${_arne_var} MATCHES "${_arne_regex}")
        cpp_raise(
            ASSERTION_FAILED
            "${_arne_var} satisfies regex: ${_arne_regex}."
        )
    endif()
endfunction()