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
# Adds a test section, should be called inside of a
# declared test function directly before declaring the section function.
#
# A variable named :code:`CMAKETEST_SECTION` will be set in the
# calling scope that holds the section function ID. Use this variable
# to define the CMake function holding the section code. Ex:
#
# .. code-block:: cmake
#
#    #This is inside of a declared test function
#    ct_add_section(NAME this_section)
#    function(${CMAKETEST_SECTION})
#        message(STATUS "This code will run in a test section")
#    endfunction()
#
#
# Additionally, the NAME parameter will be populated as by set() with the
# generated section function name. This is for backwards-compatibility
# purposes. Ex:
#
# .. code-block:: cmake
#
#    #This is inside of a declared test function
#    ct_add_section(NAME this_section)
#    function(${this_section})
#        message(STATUS "This code will run in a test section")
#    endfunction()
#
# This behavior is considered deprecated, use the first form
# for new sections.
#
# Print length of pass/fail lines can be adjusted with the `PRINT_LENGTH` option.
#
# Priority for print length is as follows (first most important):
#  1. Current execution unit's PRINT_LENGTH option
#  2. Parent's PRINT_LENGTH option
#  3. Length set by ct_set_print_length()
#  4. Built-in default of 80.
#
# If a section raises an exception when it is not expected to,
# it will be marked as a failing section and its subsections
# will not be executed, due to limitations in how CMake handles failures.
# However, sibling sections as well as other tests
# will continue to execute, and the failures will be aggregated
# and printed after all tests have been ran.
#
# **Keyword Arguments**
#
# :keyword NAME: Required argument specifying the name variable of the section. Will set a variable with
#                specified name containing the generated function ID to use.
# :type NAME: str*
# :keyword EXPECTFAIL: Option indicating whether the section is expected to fail or not, if
#                      specified will cause test failure when no exceptions were caught and success
#                      upon catching any exceptions.
# :type EXPECTFAIL: option
# :keyword PRINT_LENGTH: Optional argument specifying the desired
#                        print length of pass/fail output lines.
# :type PRINT_LENGTH: int
#
# .. seealso:: :func:`~cmake_test/add_test.ct_add_test` for details on EXPECTFAIL.
#
# .. seealso:: :func:`~cmake_test/exec_tests.ct_exec_tests` for details on halting tests on exceptions.
#
# Implementation Details
# ----------------------
#
# Upon being executed, this function will check if the section should be executed.
# If it is not, this function will generate an ID for the section
# function and sets the variable pointed to by the NAME parameter to it.
# It will also construct a new :class:`~cmake_test/execution_unit.CTExecutionUnit`
# instance to represent the section.
#
# If the section is supposed to be executed, this function
# will call the :meth:`~cmake_test/execution_unit.CTExecutionUnit.execute`
# method of the unit representing this section.
# Exceptions will be tracked while the function is being executed.
# After completion of the test, the test status will be output
# using :meth:`~cmake_test/execution_unit.CTExecutionUnit.print_pass_or_fail`.
# The section's subsections will then be executed recursively, following
# this same flow until there are no more subsections.
#
#
#]]
function(ct_add_section)

    #####################################
    #   Context switch and arg parsing  #
    #####################################

    # Set debug mode to what it should be for cmaketest, in case the test changed it
    set(_as_temp_debug_mode "${CMAKEPP_LANG_DEBUG_MODE}")
    cpp_get_global(_as_ct_debug_mode "CT_DEBUG_MODE")
    set(CMAKEPP_LANG_DEBUG_MODE "${_as_ct_debug_mode}")
    cpp_set_global("CT_CURR_TEST_DEBUG_MODE" "${_as_temp_debug_mode}")

    # Parse the arguments
    cpp_get_global(_as_curr_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
    CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_print_length print_length)
    CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_print_length_forced print_length_forced)

    set(_as_options EXPECTFAIL)
    set(_as_one_value_args NAME PRINT_LENGTH)
    set(_as_multi_value_args "")
    unset(CT_ADD_SECTION_NAME)
    cmake_parse_arguments(CT_ADD_SECTION "${_as_options}" "${_as_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )


    if(NOT DEFINED CT_ADD_SECTION_NAME OR CT_ADD_SECTION_NAME STREQUAL "")
        cpp_raise(CT_INVALID_NAME_ERROR "A section was not given a name. Use the NAME keyword argument to provide a non-empty string name.")
    endif()

    # This is to set a default value for the print length
    # argument to prevent any weird empty strings from getting through
    if(NOT DEFINED CT_ADD_SECTION_PRINT_LENGTH)
        set(CT_ADD_SECTION_PRINT_LENGTH 0)
    endif()


    # Assert sig doesn't work too well with the position agnostic kwargs,
    # so first we parse the arguments and then we check their types.
    # Right now, allow any type for the name
    cpp_assert_signature("${CT_ADD_SECTION_NAME};${CT_ADD_SECTION_PRINT_LENGTH}" str int)

    #####################################
    #      Print length detection       #
    #####################################

    set(_as_print_length_forced "NO")

    # Set default print length to CT_PRINT_LENGTH. Can be overriden
    # with PRINT_LENGTH option to this function or parent execution unit
    set(_as_print_length "${CT_PRINT_LENGTH}")
    if(CT_ADD_SECTION_PRINT_LENGTH GREATER 0)
        set(_as_print_length_forced "YES")
        set(_as_print_length "${CT_ADD_SECTION_PRINT_LENGTH}")
    elseif(_as_parent_print_length_forced)
        set(_as_print_length "${_as_parent_print_length}")
    endif()


    #####################################
    #   Name retrieval and generation   #
    #####################################

    CTExecutionUnit(GET "${_as_curr_instance}" _as_sibling_sections_map section_names_to_ids)
    cpp_map(GET "${_as_sibling_sections_map}" _as_curr_section_id "${CT_ADD_SECTION_NAME}")

    # Unset in main interpreter, TRUE in subprocess
    cpp_get_global(_as_exec_expectfail "CT_EXEC_EXPECTFAIL")

    # The name is set to "_" in the expectfail subprocess
    # if the test is not intended to be ran

    # Tracks whether the section name was already set, so we don't
    # try to read it from the siblings map or try to generate one
    set(_as_name_set FALSE)

    if(_as_exec_expectfail)
        CTExecutionUnit(is_in_expect_fail_tgt "${_as_curr_instance}" _as_in_tgt_path)
        
        # Checks whether the section's name was set in the expectfail template,
        # indicating it should run. If it's not set, then we check if the expectfail
        # target is a parent of this section, since children of an expectfail section
        # are only discovered in the subprocess.
        if(("${${CT_ADD_SECTION_NAME}}" STREQUAL "" OR "${${CT_ADD_SECTION_NAME}}" STREQUAL "_") AND NOT _as_in_tgt_path)
            set("${CT_ADD_SECTION_NAME}" "_" PARENT_SCOPE)
            set(CMAKETEST_SECTION "_" PARENT_SCOPE)
            # Reset debug mode in case test changed it
            set(CMAKEPP_LANG_DEBUG_MODE "${_as_temp_debug_mode}")
            return() #If section is not part of the call tree, immediately return
        elseif(NOT ("${${CT_ADD_SECTION_NAME}}" STREQUAL "" OR "${${CT_ADD_SECTION_NAME}}" STREQUAL "_"))
            # The name was set by either the expectfail template or by a previous execution
            set(_as_section_name "${${CT_ADD_SECTION_NAME}}")
            set(_as_name_set TRUE)
        endif()
    endif()

    # Check if the name for this section is set,
    # if so then retrieve it, else generate it

    # Get whether we should execute section now
    CTExecutionUnit(GET "${_as_curr_instance}" _as_exec_section execute_sections)

    CTExecutionUnit(GET "${_as_curr_instance}" _as_siblings section_names_to_ids)
    cpp_map(HAS_KEY "${_as_siblings}" _as_unit_created "${CT_ADD_SECTION_NAME}")
    if(NOT _as_unit_created AND NOT _as_name_set)
         cpp_unique_id(_as_section_name) # Generate random section ID
    elseif(_as_unit_created)
         cpp_map(GET "${_as_siblings}" _as_section_name "${CT_ADD_SECTION_NAME}")
         # The only time that the name would be previously set and it's not time to execute
         # is when there was a duplicated section in the same scope
         if(NOT _as_exec_section)
              cpp_raise(CT_DUPLICATE_SECTION_ERROR "Two sections with the same name '${CT_ADD_SECTION_NAME}' exist in the same scope, please rename one of them.")
              return()
         endif()
    endif()


    # Set the output variables

    # Need to duplicate because CMake scoping rules are inconsistent.
    # Setting in parent scope does not set in current scope
    set("${CT_ADD_SECTION_NAME}" "${_as_section_name}")
    set("${CT_ADD_SECTION_NAME}" "${_as_section_name}" PARENT_SCOPE)

    set("CMAKETEST_SECTION" "${_as_section_name}")
    set("CMAKETEST_SECTION" "${_as_section_name}" PARENT_SCOPE)

    #####################################
    #  Execution and unit construction  #
    #####################################

    # Get whether we should execute section now
    CTExecutionUnit(GET "${_as_curr_instance}" _as_exec_section execute_sections)

    if(_as_exec_section) # Time to execute our section
        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_children children)
        cpp_map(GET "${_as_parent_children}" _as_curr_section_instance "${_as_curr_section_id}")
        # Debug mode reset in execute()
        CTExecutionUnit(execute "${_as_curr_section_instance}")
    else()
        # Not time to execute, but we only want to define if our parent
        # doesn't already have an entry for us
        CTExecutionUnit(GET "${_as_curr_instance}" _as_siblings section_names_to_ids)
        cpp_map(HAS_KEY "${_as_siblings}" _as_unit_created "${CT_ADD_SECTION_NAME}")
        if(NOT _as_unit_created)
            # First time run, construct and configure
            # the new section unit, as well as add it
            # to its parent



            CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_file test_file)
            CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_section_depth section_depth)

            math(EXPR _as_new_section_depth "${_as_parent_section_depth} + 1")

            CTExecutionUnit(
                CTOR
                _as_new_section
                "${CMAKETEST_SECTION}"
                "${CT_ADD_SECTION_NAME}"
                "${CT_ADD_SECTION_EXPECTFAIL}"
            )
            CTExecutionUnit(SET "${_as_new_section}" parent "${_as_curr_instance}")
            CTExecutionUnit(SET "${_as_new_section}" print_length_forced "${_as_print_length_forced}")
            CTExecutionUnit(SET "${_as_new_section}" print_length "${_as_print_length}")
            CTExecutionUnit(SET "${_as_new_section}" test_file "${_as_parent_file}")
            CTExecutionUnit(SET "${_as_new_section}" section_depth "${_as_new_section_depth}")
            CTExecutionUnit(SET "${_as_new_section}" debug_mode "${_as_temp_debug_mode}")
            CTExecutionUnit(append_child "${_as_curr_instance}" "${CMAKETEST_SECTION}" "${_as_new_section}")
            CTExecutionUnit(GET "${_as_curr_instance}" _as_siblings section_names_to_ids)
            cpp_map(SET "${_as_siblings}" "${CT_ADD_SECTION_NAME}" "${CMAKETEST_SECTION}")

        endif()
        # Reset debug mode in case test changed it
        set(CMAKEPP_LANG_DEBUG_MODE "${_as_temp_debug_mode}")
    endif()

endfunction()
