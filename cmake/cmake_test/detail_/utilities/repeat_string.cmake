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
include(cmake_test/detail_/utilities/return)

#[[[
# Creates a string by repeating a substring
#
# This function is used to create a new string by repeating a substring a
# specified number of times. This is useful for creating the proper indents
# for printing and for creating repeated characters like in banners.
#
# :param result: An identifier to save the result to.
# :type result: desc*
# :param str: The substring to repeat.
# :type str: str
# :param n: The number of times to repeat ``${str}``.
# :type n: int
# :returns: A string containing the created string. The result is accessible to
#           the caller via ``result``.
#]]
function(_ct_repeat_string _rs_result _rs_str _rs_n)
    cpp_assert_signature("${ARGV}" desc* str int)
    set(_rs_counter 0)
    while(_rs_counter LESS _rs_n)
        set(${_rs_result} "${${_rs_result}}${_rs_str}")
        math(EXPR _rs_counter "${_rs_counter} + 1")
    endwhile()
    _ct_return("${_rs_result}")
endfunction()
