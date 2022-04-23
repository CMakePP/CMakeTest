include_guard()

#[[[
# Constructs the files needed for a test to be executed in a subprocess and then executes the subprocess.
#
# This function will only be called for sections marked with EXPECTFAIL. Subprocesses are required because
# there is no way to handle exceptions correctly and not leave a test in an indeterminate state. A full
# interpreter shutdown is required to prevent code from proceeding from the exception point as if nothing
# had happened.
#
# This function first pulls data about the current execution unit and the current section from globals,
# then builds a tree describing the section's parents. This tree is then converted to a list of variable
# declarations and inserted into a template CMakeLists.txt. These declarations ensure only the section and
# its direct parents are executed to prevent a different section or test from running. Finally, the template
# is executed in a subprocess, resulting in the section and its parents being executed. The subprocess result
# code is stored, and if the code is reported as succeeding testing is halted since we expect it to fail.
#
# :param _es_curr_exec_unit: The current execution unit, used to pull information from the globals.
# :type _es_curr_exec_unit: string
# :param _es_curr_section: The current section, used to pull information from the globals and to calculate the parent tree.
# :type _es_curr_section: string
#
#]]
function(ct_expectfail_subprocess _es_curr_section_instance)

                CTExecutionUnit(GET "${_es_curr_section_instance}" _es_print_length print_length)
                CTExecutionUnit(get_parent_list "${_es_curr_section_instance}" _es_section_parent_tree)
                CTExecutionUnit(GET "${_es_curr_section_instance}" _es_section_id test_id)
                CTExecutionUnit(GET "${_es_curr_section_instance}" _es_section_friendly_name friendly_name)
                CTExecutionUnit(GET "${_es_curr_section_instance}" _es_section_file test_file)

                list(REMOVE_ITEM _es_section_parent_tree "") #Remove empty list items



                #Traverse the parent list and construct the section ID definitions
                set(_es_section_id_defines "") #Set a blank ID list in case one is already defined
                foreach(_es_parent_tree_instance IN LISTS _es_section_parent_tree)
                     CTExecutionUnit(GET "${_es_parent_tree_instance}" _es_parent_tree_id test_id)
                     set(_es_parent_friendly_name "") #Clear
                     CTExecutionUnit(GET "${_es_parent_tree_instance}" _es_parent_friendly_name friendly_name)
                     list(APPEND _es_section_id_defines "set(${_es_parent_friendly_name} \"${_es_parent_tree_id}\")")
                endforeach()

                #Append this section's ID definition so it is executed
                list(APPEND _es_section_id_defines "set(${_es_section_friendly_name} \"${_es_section_id}\")")

                #Replace list delimiters with newlines for full call list
                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\n" _es_section_id_defines "${_es_section_id_defines}")

                #Force delimiter at the end
                list(APPEND _es_section_parent_tree "")

                #Replace list-delimiters with newlines and parentheses, constructing a function call list
                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\(\)\n" _es_section_parent_tree "${_es_section_parent_tree}")

                #Write subprocess file
                configure_file("${_CT_TEMPLATES_DIR}/expectfail.txt" "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_section_id}_EXPECTFAIL/CMakeLists.txt" @ONLY) #Fill in boilerplate, copy to build dir

                #Exec subprocess
                file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_section_id}_EXPECTFAIL/build")
                execute_process(COMMAND "${CMAKE_COMMAND}" -S "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_section_id}_EXPECTFAIL/" -B "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_section_id}_EXPECTFAIL/build/" RESULT_VARIABLE _es_expectfail_result_code OUTPUT_VARIABLE _es_expectfail_output ERROR_VARIABLE _es_expectfail_stderr)

                #Check exit code and crash if did not fail when expected
                if (NOT _es_expectfail_result_code)
                     #TODO provide details once CMakePPLang#52 is resolved
                     #cpp_raise(EXPECTFAIL_NO_FAILURE_EXCEPTION "Section ${_es_section_friendly_name} was expected to fail but instead returned ${_es_expectfail_result_code}.\n"
                     #    "Subprocess output: ${_es_expectfail_output}\n"
                     #    "Subprocess error: ${_es_expectfail_stderr}"
                     #)
                     cpp_raise(EXPECTFAIL_NO_FAILURE_EXCEPTION "Section ${_es_section_friendly_name} was expected to fail but instead returned ${_es_expectfail_result_code}.")
                endif()

endfunction()
