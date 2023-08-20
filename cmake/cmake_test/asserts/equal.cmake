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
include("cmakepp_lang/asserts/signature")

#[[[
# Asserts that an identifier contains the specified contents.
#
# This function is used to assert that a given pointer is set to the
# specified contents. If the pointer does not dereference to the specified
# contents, an :code:`ASSERTION_FAILED` exception is raised.
#
# :param var: The identifier whose contents are in question.
# :type var: str*
# :param contents: What the pointer should dereference to
# :type contents: str
#]]
function(ct_assert_equal _ae_var _ae_contents)
    # Can't assert signature since could be used for lists and that
    # breaks cpp_assert_signature
    if(NOT "${${_ae_var}}" STREQUAL "${_ae_contents}")
        cpp_raise(
            ASSERTION_FAILED
            "Assertion: ${${_ae_var}} == ${_ae_contents} failed. "
            "${_ae_var} contents: ${${_ae_var}}"
        )
    endif()
endfunction()

#[[[
# Asserts that an identifier does not contain the specified contents.
#
# This function is used to assert that a given identifier is set to something
# other than the specified contents. If the pointer does dereference to the specified
# contents, then an :code:`ASSERTION_FAILED` exception will be raised.
#
# :param var: The identifier whose contents are in question.
# :type var: str*
# :param contents: What the pointer should not dereference to
# :type contents: str
#]]
function(ct_assert_not_equal _ane_var _ane_contents)
    # Can't assert signature since could be used for lists and that
    # breaks cpp_assert_signature
    if("${${_ane_var}}" STREQUAL "${_ane_contents}")
        cpp_raise(
           ASSERTION_FAILED
           "Assertion: ${${_ane_var}} != ${_ane_contents} failed. "
           "${_ane_var} contents: ${${_ane_var}}"
        )
    endif()
endfunction()
