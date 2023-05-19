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

#[[[ Asserts that the provided variable is true.
#
# :param _at_var: The identifier to check for trueness.
# :type _at_var: Identifier
#]]
function(ct_assert_true _at_var)
    if(NOT ${_at_var})
        message(FATAL_ERROR "${_at_var} is not true.")
    endif()
endfunction()

#[[[ Asserts that the provided variable is false.
#
# :param _af_var: The identifier to check for falseness.
# :type _af_var: Identifier
#]]
function(ct_assert_false _af_var)
    if(${_af_var})
        message(FATAL_ERROR "${_af_var} is not false.")
    endif()
endfunction()
