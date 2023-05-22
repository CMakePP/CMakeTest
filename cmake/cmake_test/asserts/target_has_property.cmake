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
include(cmake_test/asserts/target_exists)


#[[[ Assert that a target has a property.
#
# :param _athp_target: The name of the target
# :type _athp_target: String
# :param _athp_property: The name of the property
# :type _athp_property: String
#]]
function(ct_assert_target_has_property _athp_target _athp_property)
    # Ensure the target exists
    ct_assert_target_exists("${_athp_target}")

    # Check if the property exists for the target, if not, throw error
    get_target_property(_athp_res "${_athp_target}" "${_athp_property}")
    if(NOT _athp_res)
        message(
            FATAL_ERROR
            "Target ${_athp_target} does not contain property ${_athp_property}"
        )
    endif()
endfunction()

#[[[ Assert that a target does not have a property.
#
# :param _atdnhp_target: The name of the target
# :type _atdnhp_target: String
# :param _atdnhp_property: The name of the property
# :type _atdnhp_property: String
#]]
function(ct_assert_target_does_not_have_property _atdnhp_target _atdnhp_property)
    # Ensure the target exists
    ct_assert_target_exists("${_atdnhp_target}")

    # Check if the property exists for the target, if it does, throw error
    get_target_property(_atdnhp_res "${_atdnhp_target}" "${_atdnhp_property}")
    if(_atdnhp_res)
        message(
            FATAL_ERROR
            "Target ${_atdnhp_target} contains property ${_atdnhp_property}"
        )
    endif()
endfunction()
