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

#[[[ Defines a unit test for the CMakeTest framework.
#
# Unit testing in CMakeTest works by `include()`ing each unit test, determining which ones
# need to be ran, and then executing them sequentially in-process. This macro defines which functions
# are to be interpretted as actual unit tests.
#
# A variable named :code:`CMAKETEST_TEST` will be set in the
# calling scope that holds the test function ID. Use this variable
# to define the CMake function holding the section code. Ex:
#
# .. code-block:: cmake
#
#    ct_add_test(NAME [=[Any test name here]=])
#    function(${CMAKETEST_TEST})
#        message(STATUS "This code will run in a test")
#    endfunction()
#
#
# Additionally, the NAME parameter will be populated as by set() with the
# generated section function name. This is for backwards-compatibility
# purposes. Ex:
#
# .. code-block:: cmake
#
#    ct_add_test(NAME this_test)
#    function(${this_test})
#        message(STATUS "This code will run in a test")
#    endfunction()
#
# This behavior is considered deprecated, use the first form
# for new tests.
#
# Print length of pass/fail lines can be adjusted with the `PRINT_LENGTH` option.
#
# Priority for print length is as follows (first most important):
#  1. Current execution unit's PRINT_LENGTH option
#  2. Parent's PRINT_LENGTH option
#  3. Length set by ct_set_print_length()
#  4. Built-in default of 80.
#
#
# **Keyword Arguments**
#
# :keyword NAME: Required argument specifying the name variable of the section.
#                Will set a variable with specified name containing the generated function ID to use.
# :type NAME: pointer
# :keyword EXPECTFAIL: Option indicating whether the section is expected to fail or not,
#                      if specified will cause test failure when no exceptions were caught and
#                      success upon catching any exceptions.
# :type EXPECTFAIL: option
# :keyword PRINT_LENGTH: Optional argument specifying the desired print length of pass/fail output lines.
# :type PRINT_LENGTH: int
#
#]]
macro(ct_add_test)

    #####################################
    #   Context switch and arg parsing  #
    #####################################

    # Set debug mode to what it should be for cmaketest, in case the test changed it
    set(_at_temp_debug_mode "${CMAKEPP_LANG_DEBUG_MODE}")
    cpp_get_global(_at_ct_debug_mode "CT_DEBUG_MODE")
    set(CMAKEPP_LANG_DEBUG_MODE "${_at_ct_debug_mode}")
    cpp_set_global("CT_CURR_TEST_DEBUG_MODE" "${_at_temp_debug_mode}")

    cpp_get_global(_at_exec_unit_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
    cpp_get_global(_at_exec_expectfail "CT_EXEC_EXPECTFAIL") #Unset in main interpreter, TRUE in subprocess

    if(NOT ("${_at_exec_unit_instance}" STREQUAL "") AND NOT _at_exec_expectfail)
        CTExecutionUnit(GET "${_at_exec_unit_instance}" _at_exec_unit_friendly_name friendly_name)
        ct_exit(
            "ct_add_test() encountered while executing a CMakeTest test or section named \"${_at_exec_unit_friendly_name}\""
        )
    endif()



    set(_at_options EXPECTFAIL)
    set(_at_one_value_args NAME PRINT_LENGTH)
    set(_at_multi_value_args "")
    cmake_parse_arguments(CT_ADD_TEST "${_at_options}" "${_at_one_value_args}"
                          "${_at_multi_value_args}" ${ARGN} )

    if(NOT DEFINED CT_ADD_TEST_NAME OR CT_ADD_TEST_NAME STREQUAL "")
        cpp_raise(CT_INVALID_NAME_ERROR "A test was not given a name. Use the NAME keyword argument to provide a non-empty string name.")
    endif()

    if(_at_exec_expectfail AND ("${${CT_ADD_TEST_NAME}}" STREQUAL "" OR "${${CT_ADD_TEST_NAME}}" STREQUAL "_"))
            set("${CT_ADD_TEST_NAME}" "_")
            set(CMAKETEST_TEST "_")
            # Reset debug mode in case test changed it
            set(CMAKEPP_LANG_DEBUG_MODE "${_at_temp_debug_mode}")
    else()

        set(_at_print_length_forced "NO")

        #Default to ${CT_PRINT_LENGTH}, if PRINT_LENGTH option set to valid number then override
        set(_at_print_length "${CT_PRINT_LENGTH}")
        if(CT_ADD_TEST_PRINT_LENGTH GREATER 0)
            set(_at_print_length_forced "YES")
            set(_at_print_length "${CT_ADD_TEST_PRINT_LENGTH}")
        endif()

        set(_at_old_id "${${CT_ADD_TEST_NAME}}")

        if(_at_old_id STREQUAL "")
            cpp_unique_id("${CT_ADD_TEST_NAME}")
            set(CMAKETEST_TEST "${${CT_ADD_TEST_NAME}}")
        endif()

        if(_at_exec_expectfail OR ("${_at_old_id}" STREQUAL ""))
            CTExecutionUnit(
                CTOR
                test_instance
                "${${CT_ADD_TEST_NAME}}"
                "${CT_ADD_TEST_NAME}"
                "${CT_ADD_TEST_EXPECTFAIL}"
            )
            CTExecutionUnit(SET "${test_instance}" print_length "${_at_print_length}")
            CTExecutionUnit(SET "${test_instance}" print_length_forced "${_at_print_length_forced}")
            CTExecutionUnit(SET "${test_instance}" test_file "${CMAKE_CURRENT_LIST_FILE}")
            CTExecutionUnit(SET "${test_instance}" debug_mode "${_at_temp_debug_mode}")

            cpp_append_global("CMAKETEST_TEST_INSTANCES" "${test_instance}")

            message(
                "Test w/ friendly name \"${CT_ADD_TEST_NAME}\" has ID \"${${CT_ADD_TEST_NAME}}\" and file \"${CMAKE_CURRENT_LIST_FILE}\""
            )
        endif()

        # Reset debug mode in case test changed it
        set(CMAKEPP_LANG_DEBUG_MODE "${_at_temp_debug_mode}")
    endif()
endmacro()




