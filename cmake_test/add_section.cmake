include_guard()


#[[[
# Adds a test section, should be called inside of a declared test function directly before declaring the section function.
# The NAME parameter will be populated as by set() with the generated section function name. Declare the section function using this generated name. Ex:
#
# .. code-block:: cmake
#
#    #This is inside of a declared test function
#    ct_add_section(NAME this_section)
#    function(${this_section})
#        message(STATUS "This code will run in a test section")
#    endfunction()
#
# Upon being executed, this function will check if the CMAKETEST_TEST_${current_exec_unit}_EXECUTE_SECTIONS CMakePP global is set.
# If it is not, ct_add_section() will generate an ID for the section function and sets the variable pointed to by the NAME parameter to it.
#
# If the flag is set, ct_add_section() will increment the CMAKETEST_SECTION_DEPTH CMakePP global, write a file to the build directory with a line calling the section function,
# and include the file to execute the function. Exceptions will be tracked while the function is being executed. After completion of the test, the test status will be output
# to the screen. The CMAKETEST_TEST_${current_exec_unit}_${section_id}_EXECUTE_SECTIONS flag will then be set. The section function will then be executed again, and
# any subsections will then execute as well, following this same flow until there are no more subsections. Section depth is tracked by the CMAKETEST_SECTION_DEPTH CMakePP global.
#
# If a section raises an exception when it is not expected to, testing will halt immediately. To keep parity between different types of tests, EXPECTFAIL sections that do not raise
# exceptions will also halt all testing.
#
#
# :param **kwargs: See below
#
# :Keyword Arguments:
#    * *NAME* (``pointer``) -- Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.
#    * *EXPECTFAIL* (``option``) -- Option indicating whether the section is expected to fail or not, if specified will cause test failure when no exceptions were caught and success upon catching any exceptions.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#
# .. seealso:: :func:`exec_test.cmake.ct_exec_test` for details on halting tests on exceptions.
#
#]]
macro(ct_add_section)

    #TODO Set sections as a subproperty of CT_CURRENT_EXECUTION_UNIT instead of as a single global variable
    set(_as_options EXPECTFAIL)
    set(_as_one_value_args NAME)
    set(_as_multi_value_args "")
    cmake_parse_arguments(CT_ADD_SECTION "${_as_options}" "${_as_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )


    cpp_get_global(_as_curr_exec_unit "CT_CURRENT_EXECUTION_UNIT")
    cpp_get_global(_as_curr_section "CMAKETEST_TEST_${_as_curr_exec_unit}_${CT_ADD_SECTION_NAME}_ID")

    if("${${CT_ADD_SECTION_NAME}}" STREQUAL "")
         cpp_unique_id("${CT_ADD_SECTION_NAME}") #Generate random section ID
         #cpp_get_global(_as_curr_sections "CMAKETEST_TEST_${_as_curr_exec_unit}_SECTIONS")
         #list(APPEND _as_curr_sections "${${CT_ADD_SECTION_NAME}}")
         #set_property(GLOBAL PROPERTY CMAKETEST_TEST_${_as_curr_exec_unit}_SECTIONS "${_as_curr_sections}") #Append the section ID to the list of sections, since this will be executed in the test's scope we need to set it in pare>
         cpp_append_global(CMAKETEST_TEST_${_as_curr_exec_unit}_SECTIONS "${${CT_ADD_SECTION_NAME}}")

         #message(STATUS "Adding section: ${CT_ADD_SECTION_NAME}")
    endif()


    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_EXPECTFAIL" "${CT_ADD_SECTION_EXPECTFAIL}") #Set a flag for whether the section is expected to fail or not
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_FRIENDLY_NAME" "${CT_ADD_SECTION_NAME}") #Store the friendly name for the test


    #Store this section's parent and its parents so we can trace the execution path back
    cpp_get_global(_as_parents_parent_tree "CMAKETEST_TEST_${_as_curr_exec_unit}_PARENT_TREE") #Get our parent's parent tree
    if(_as_parents_parent_tree STREQUAL "") #If parent is root test
        set(_as_parents_parent_tree "${_as_curr_exec_unit}") #Set parent tree to root
    endif()
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PARENT_TREE" "${_as_parents_parent_tree};${${CT_ADD_SECTION_NAME}}")
    #cpp_append_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PARENT_TREE" "${${CT_ADD_SECTION_NAME}}")
    cpp_get_global(_as_test_tree "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PARENT_TREE")

    list(GET _as_test_tree 1 _as_test_tree_first)


    #set(_as_curr_section "${${CT_ADD_SECTION_NAME}}")
    set(_as_original_unit "${_as_curr_exec_unit}")
    cpp_get_global(_as_exec_section "CMAKETEST_TEST_${_as_curr_exec_unit}_EXECUTE_SECTIONS") #Get whether we should execute section now

    if(_as_exec_section)
        cpp_get_global(_as_old_section_depth "CMAKETEST_SECTION_DEPTH")
        math(EXPR _as_new_section_depth "${_as_old_section_depth} + 1")
        cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_new_section_depth}")
        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}_${_as_curr_section}")
        cpp_get_global(_as_friendly_name "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_FRIENDLY_NAME")



        cpp_get_global(_as_expect_fail "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXPECTFAIL")

        #get_property(ct_exception_details GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTION_DETAILS")
        #message(STATUS "Executing section named \"${_as_friendly_name}\", expectfail=${_as_expect_fail}")

        cpp_get_global(_as_exec_expectfail "CT_EXEC_EXPECTFAIL") #Unset in main interpreter, TRUE in subprocess

        if(_as_expect_fail)

            if(NOT _as_exec_expectfail)
                cpp_get_global(_as_section_parent_tree "CMAKETEST_TEST_${_as_curr_exec_unit}_${_as_curr_section}_PARENT_TREE")

                list(REMOVE_ITEM _as_section_parent_tree "") #Remove empty list items


                list(GET _as_section_parent_tree 0 _as_section_root) #Get the root test
                cpp_get_global(_as_section_root_file "CMAKETEST_TEST_${_as_section_root}_FILE")

                set(_as_section_id_defines "") #Set a blank ID list in case one is already defined
                set(_as_constructed_exec_unit "") #Blank constructed exec unit. This will be expanded in the following foreach loop as the parent list is traversed
                foreach(_as_parent_tree_id IN LISTS _as_section_parent_tree)
                     set(_as_parent_friendly_name "") #Clear
                     if(_as_constructed_exec_unit STREQUAL "")
                          cpp_get_global(_as_parent_friendly_name "CMAKETEST_TEST_${_as_parent_tree_id}_FRIENDLY_NAME")
                          set(_as_constructed_exec_unit ${_as_parent_tree_id})
                          #list(APPEND _as_section_id_defines "cpp_set_global(\"CMAKETEST_TEST_${_as_parent_friendly_name}_ID\" ${_as_parent_tree_id})")
                     else()
                          cpp_get_global(_as_parent_friendly_name "CMAKETEST_TEST_${_as_constructed_exec_unit}_${_as_parent_tree_id}_FRIENDLY_NAME")
                          set(_as_constructed_exec_unit "${_as_constructed_exec_unit}_${_as_parent_tree_id}")
                          #list(APPEND _as_section_id_defines "cpp_set_global(\"CMAKETEST_TEST_${_as_constructed_exec_unit}_${_as_parent_friendly_name}_ID\" ${_as_parent_tree_id})")
                     endif()
                     list(APPEND _as_section_id_defines "set(${_as_parent_friendly_name} \"${_as_parent_tree_id}\")")
                endforeach()

                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\n" _as_section_id_defines "${_as_section_id_defines}") #Replace list delimiters with newlines for full call list

                list(APPEND _as_section_parent_tree "") #Force delimiter at the end
                string (REGEX REPLACE "(^|[^\\\\]);" "\\1\(\)\n" _as_section_parent_tree "${_as_section_parent_tree}") #Replace list-delimiters with newlines and parentheses, constructing a function call list
                #Write subprocess file, exec subprocess
                configure_file("${_ct_add_dir_file_dir}/templates/template_expectfail.txt" "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}_EXPECTFAIL/CMakeLists.txt" @ONLY) #Fill in boilerplate, copy to build dir


                file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}_EXPECTFAIL/build")
                execute_process(COMMAND "${CMAKE_COMMAND}" -S "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}_EXPECTFAIL/" -B "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}_EXPECTFAIL/build/" RESULT_VARIABLE _as_expectfail_result_code OUTPUT_VARIABLE _as_expectfail_output ERROR_VARIABLE _as_expectfail_stderr)
                #message("Subprocess output: ${_as_expectfail_output}")
                #message("Subprocess exit code: ${_as_expectfail_result_code}")
                if (NOT _as_expectfail_result_code)
                     ct_exit("Section ${CT_ADD_SECTION_NAME} was expected to fail but instead returned ${_as_expectfail_result_code}. Subprocess output: ${_as_expectfail_output}\nSubprocess error: ${_as_expectfail_stderr}")
                endif()

           else()
                file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake" "${_as_curr_section}()")
                include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")
           endif()

        else()
            file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake" "${_as_curr_section}()")
            include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")
            cpp_get_global(_as_exceptions "${_as_original_unit}_${_as_curr_section}_EXCEPTIONS")

            if(NOT "${_as_exceptions}" STREQUAL "")
                foreach(_as_exc IN LISTS _as_exceptions)
                    message("${CT_BoldRed}Section named \"${_as_friendly_name}\" raised exception:")
                    message("${_as_exc}${CT_ColorReset}")
                endforeach()
                set(_as_section_fail "TRUE")
           endif()
       endif()
       if(_as_section_fail)
           _ct_print_fail("${_as_friendly_name}" "${_as_new_section_depth}")
           cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
           ct_exit()
       else()
           _ct_print_pass("${_as_friendly_name}" "${_as_new_section_depth}")
       endif()


       if(NOT _as_expect_fail AND NOT _as_exec_expectfail)
           #Execute the section again, this time executing subsections. Only do when not executing expectfail
           cpp_set_global("CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXECUTE_SECTIONS" TRUE)
           include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")
           cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}")
           cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_old_section_depth}")
      endif()
    else()
        #First time run, set the ID so we don't lose it on the second run.
        #This will only cause conflicts if two sections in the same test
        #use the same friendly name (the variable used to store the ID and used in the function definition), which no sane programmer would do
        cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${CT_ADD_SECTION_NAME}_ID" "${${CT_ADD_SECTION_NAME}}")

    endif()

endmacro()
