
function(ct_expectfail_subprocess _es_curr_exec_unit _es_curr_section)
                cpp_get_global(_es_section_parent_tree "CMAKETEST_TEST_${_es_curr_exec_unit}_${_es_curr_section}_PARENT_TREE")

                list(REMOVE_ITEM _es_section_parent_tree "") #Remove empty list items


                list(GET _es_section_parent_tree 0 _es_section_root) #Get the root test
                cpp_get_global(_es_section_root_file "CMAKETEST_TEST_${_es_section_root}_FILE")

                set(_es_section_id_defines "") #Set a blank ID list in case one is already defined
                set(_es_constructed_exec_unit "") #Blank constructed exec unit. This will be expanded in the following foreach loop as the parent list is traversed
                foreach(_es_parent_tree_id IN LISTS _es_section_parent_tree)
                     set(_es_parent_friendly_name "") #Clear
                     if(_es_constructed_exec_unit STREQUAL "")
                          cpp_get_global(_es_parent_friendly_name "CMAKETEST_TEST_${_es_parent_tree_id}_FRIENDLY_NAME")
                          set(_es_constructed_exec_unit ${_es_parent_tree_id})
                          #list(APPEND _es_section_id_defines "cpp_set_global(\"CMAKETEST_TEST_${_es_parent_friendly_name}_ID\" ${_es_parent_tree_id})")
                     else()
                          cpp_get_global(_es_parent_friendly_name "CMAKETEST_TEST_${_es_constructed_exec_unit}_${_es_parent_tree_id}_FRIENDLY_NAME")
                          set(_es_constructed_exec_unit "${_es_constructed_exec_unit}_${_es_parent_tree_id}")
                          #list(APPEND _es_section_id_defines "cpp_set_global(\"CMAKETEST_TEST_${_es_constructed_exec_unit}_${_es_parent_friendly_name}_ID\" ${_es_parent_tree_id})")
                     endif()
                     list(APPEND _es_section_id_defines "set(${_es_parent_friendly_name} \"${_es_parent_tree_id}\")")
                endforeach()

                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\n" _es_section_id_defines "${_es_section_id_defines}") #Replace list delimiters with newlines for full call list

                list(APPEND _es_section_parent_tree "") #Force delimiter at the end
                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\(\)\n" _es_section_parent_tree "${_es_section_parent_tree}") #Replace list-delimiters with newlines and parentheses, constructing a function call list
                #Write subprocess file, exec subprocess
                configure_file("${_ct_add_dir_file_dir}/templates/expectfail.txt" "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}_EXPECTFAIL/CMakeLists.txt" @ONLY) #Fill in boilerplate, copy to build dir

                file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}_EXPECTFAIL/build")
                execute_process(COMMAND "${CMAKE_COMMAND}" -S "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}_EXPECTFAIL/" -B "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}_EXPECTFAIL/build/" RESULT_VARIABLE _es_expectfail_result_code OUTPUT_VARIABLE _es_expectfail_output ERROR_VARIABLE _es_expectfail_stderr)
                #message("Subprocess output: ${_es_expectfail_output}")
                #message("Subprocess error: ${_es_expectfail_stderr}")
                #message("Subprocess exit code: ${_es_expectfail_result_code}")
                if (NOT _es_expectfail_result_code)
                     ct_exit("Section ${CT_ADD_SECTION_NAME} was expected to fail but instead returned ${_es_expectfail_result_code}. Subprocess output: ${_es_expectfail_output}\nSubprocess error: ${_es_expectfail_stderr}")
                endif()

endfunction()
