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

#[[[ Asserts that the provided variable is defined.
#
# This function can be used to assert that a variable is defined. It does not
# assert that the variable is set to any particular value. If the variable is
# not defined it will raise an error.
#
# :param _ad_var: The identifier to check for defined-ness.
# :type _ad_var: Identifier
#]]
function(ct_assert_defined _ad_var)
    if(NOT DEFINED ${_ad_var})
        cpp_raise(ASSERTION_FAILED "${_ad_var} is not defined.")
    endif()
endfunction()

#[[[ Asserts that the provided variable is not defined.
#
# This function can be used to assert that a variable is not defined. If the
# variable is actually defined this function will raise an error.
#
# :param _and_var: The identifier to check for defined-ness.
# :type _and_var: Identifier
#]]
function(ct_assert_not_defined _and_var)
    if(DEFINED ${_and_var})
        cpp_raise(ASSERTION_FAILED "${_and_var} is defined.")
    endif()
endfunction()
