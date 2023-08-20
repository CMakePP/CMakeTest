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
include(cmake_test/asserts/file_exists)
include(cmakepp_lang/asserts/signature)

#[[[
# Assert a file contains the specified text.
#
# Asserts that the file at the specified path contains the specified text.
# If the file does not exist or does not contain the specified contents,
# an :code:`ASSERTION_FAILED` exception is raised.
#
# :param file: The file to check
# :type file: path
# :param text: The text to check for
# :type text: str
#]]
function(ct_assert_file_contains _afc_file _afc_text)
    cpp_assert_signature("${ARGV}" path str)
    # Ensure the file exists
    ct_assert_file_exists("${_afc_file}")

    # Throw error if the file does not contain the text
    ct_file_contains(_afc_result "${_afc_file}" "${_afc_text}")
    if(NOT ${_afc_result})
        cpp_raise(
            ASSERTION_FAILED
            "File at ${_afc_file} does not contain text ${_afc_text}."
        )
    endif()
endfunction()

#[[[ Assert a file does not contain the specified text.
#
# Asserts that the file at the specified path does not contain the specified
# text.
#
# If the path does not exist or the file at that path does
# contain the text, an :code:`ASSERTION_FAILED` exception will be raised.
#
# :param file: The file to check
# :type file: path
# :param text: The text to check for
# :type text: str
#]]
function(ct_assert_file_does_not_contain _afdnc_file _afdnc_text)
    cpp_assert_signature("${ARGV}" path str)
    # Ensure the file exists
    ct_assert_file_exists("${_afdnc_file}")

    # Throw error if the file contains the text
    ct_file_contains(_afdnc_result "${_afdnc_file}" "${_afdnc_text}")
    if(${_afdnc_result})
        cpp_raise(
            ASSERTION_FAILED
            "File at ${_afdnc_file} contains text ${_afdnc_text}."
        )
    endif()
endfunction()

#[[[
# Determines if a file contains some text.
#
# This function checks whether a file contains some text and returns a boolean
# result.
#
# Will raise an :code:`ASSERTION_FAILED` exception if the file does not exist.
#
# :param result: Name to use for the variable which will hold the result.
# :type result: bool*
# :param file: The file to check.
# :type file: path
# :param text: The text to check for.
# :type text: str
# :returns: ``result`` will be set to ``TRUE`` if file contains the text
#           and ``FALSE`` if it does not.
# :rtype: bool
#]]
function(ct_file_contains _fc_result _fc_file _fc_text)
    cpp_assert_signature("${ARGV}" bool* path str)

    # Ensure the file exists
    ct_assert_file_exists("${_fc_file}")


    # Read the file to determine if it contains the text
    file(READ "${_fc_file}" _fc_contents)
    string(FIND "${_fc_contents}" "${_fc_text}" _fc_index)
    if(${_fc_index} EQUAL -1)
        set("${_fc_result}" FALSE PARENT_SCOPE)
    else()
        set("${_fc_result}" TRUE PARENT_SCOPE)
    endif()
endfunction()
