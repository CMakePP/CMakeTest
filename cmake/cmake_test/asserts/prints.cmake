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
# Asserts that a specified message was printed.
#
# This function is used to assert that a string was printed immediately
# prior to this function call. This function only compares the expected
# message with whatever was printed last, it does not compare with
# any printed messages further back.
#
# If the previously printed message does not exactly match the expected message,
# this function will treat the expected message as a regex to check if it matches.
#
# :param msg: The message expected to have been printed, either exact match or regex.
# :type msg: desc
#]]
function(ct_assert_prints _ap_msg)
    cpp_assert_signature("${ARGV}" desc)

    cpp_get_global(_ap_last_msg CT_LAST_MESSAGE)
    if(NOT ("${_ap_last_msg}" STREQUAL "${_ap_msg}"))
        #Have to have MATCHES in separate if()
        #because even if OR is short-circuited
        #CMake tries to compile the regex anyways

        if(NOT ("${_ap_last_msg}" MATCHES "${_ap_msg}"))
            cpp_raise(
                ASSERTION_FAILED
                "Assertion: Print failed.
                Expected: ${_ap_msg}
                Last message: ${_ap_last_msg}"
            )
        endif()
    endif()


endfunction()
