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
# Execute all declared tests in a file. This function will be ran after ``include()``-ing the test file.
# This function will loop over all the CTExecutionUnit instances stored in the CMAKETEST_TEST_INSTANCES
# global, executing each one. All exceptions are tracked while the test is ran, including during
# subsection execution.
#
# Pass/fail output will be printed to the screen after each test or section has been executed,
# results are not aggregated at the end to prevent a faulty test from causing the interpeter
# to fail before results are printed.
#
# A test that is not expected to fail that raises an exception or a fatal error will result in it
# be marked as failing and no subsections will be executed. However, sibling tests will continue
# to be executed. All of the failures are aggregated and printed after all tests have executed.
#
# Normally, this would not be possible due to limitations in CMake. However, using the general
# exception handler, this function is re-executed whenever there is a failure, and it will
# then continue running tests that have not yet been ran.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#
# .. seealso:: :func:`add_section.cmake.ct_add_section` for details on section execution.
#]]
function(ct_exec_tests)
    #Default to true and set to false once one does not pass
    cpp_set_global(CMAKETEST_TESTS_DID_PASS "TRUE")

    # Add general exception handler that catches all exceptions
    ct_register_exception_handler()

    cpp_get_global(_et_instances "CMAKETEST_TEST_INSTANCES")

    foreach(_et_curr_instance IN LISTS _et_instances)
        #Execute test
        CTExecutionUnit(execute "${_et_curr_instance}")
    endforeach()
endfunction()
