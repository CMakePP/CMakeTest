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
# Assert that the file at the provided path exists.
# If it does not exist or is a directory,
# an :code:`ASSERTION_FAILED` exception is raised.
#
# :param path: The path to check
# :type path: path
#]]
function(ct_assert_file_exists _afe_path)
    if(NOT EXISTS "${_afe_path}")
        cpp_raise(
         ASSERTION_FAILED
         "File does not exist at ${_afe_path}."
        )
    elseif(IS_DIRECTORY "${_afe_path}")
        message(FATAL_ERROR "${_afe_path} is a directory not a file.")
    endif()
endfunction()

#[[[
# Assert that a file does not exist at the provided path.
# If the path exists and is not a directory, an
# :code:`ASSERTION_FAILED` exception is raised.
#
# :param path: The path to check
# :type path: path
#]]
function(ct_assert_file_does_not_exist _afdne_path)
    if(EXISTS "${_afdne_path}" AND NOT IS_DIRECTORY "${_afdne_path}")
        cpp_raise(
         ASSERTION_FAILED
         "File does exist at ${_afdne_path}."
         )
    endif()
endfunction()
