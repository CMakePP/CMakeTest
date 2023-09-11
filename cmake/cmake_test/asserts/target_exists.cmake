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
# Assert that a target exists.
#
# :param name: The target's name.
# :type name: target | desc
#]]
function(ct_assert_target_exists _ate_name)
    # Check if the target exists, if not throw an error
    if(NOT TARGET "${_ate_name}")
        cpp_raise(
            ASSERTION_FAILED
            "Target ${_ate_name} does not exist."
        )
    endif()
endfunction()

#[[[
# Assert that a target does not exist.
#
# :param name: The potential target's name.
# :type name: target | desc
#]]
function(ct_assert_target_does_not_exist _atdne_name)
    # Check if the target exists, if it does, throw an error
    if(TARGET "${_atdne_name}")
        cpp_raise(
            ASSERTION_FAILED
            "Target ${_atdne_name} does exist."
        )
    endif()
endfunction()
