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
include(cmake_test/asserts/list)

#[[[ Asserts that the provided identifier is set to a value other than the empty
#    string.
#
#  This function can be used to assert that an identifier is set to a value. In
#  the event that the input to this function is not an identifier, or if that
#  identifier is not set to a value, this function will raise a fatal error.
#
#  :param var: The identifier to check for defined-ness.
#  :type var: Identifier
#]]
function(_ct_nonempty _n_var)
    cmake_policy(SET CMP0054 NEW)
    if("${${_n_var}}" STREQUAL "")
        message(FATAL_ERROR "${_n_var} is empty.")
    endif()
endfunction()

#[[[ Asserts that the identifier contains a non-empty string.
#
#  This function will ensure that the provided identifier is set to a value and
#  that that value is not the empty string. If the identifier contains a list,
#  or if the identifier is set to an empty string this function will raise a
#  fatal error.
#
#  :param var: The identifier whose contents is being examined.
#  :type var: Identifier
#]]
function(_ct_nonempty_string _ns_var)
    _ct_nonempty("${_ns_var}")
    ct_assert_not_list("${_ns_var}")
endfunction()
