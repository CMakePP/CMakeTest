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
# Print length of pass/fail lines can be adjusted with the `PRINT_LENGTH` option.
#
# Priority for print length is as follows (first most important):
#  1. Current execution unit's PRINT_LENGTH option
#  2. Parent's PRINT_LENGTH option
#  3. Length set by ct_set_print_length()
#  4. Built-in default of 80.
#
#
# :param **kwargs: See below
#
# :Keyword Arguments:
#    * *NAME* (``pointer``) -- Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.
#    * *EXPECTFAIL* (``option``) -- Option indicating whether the section is expected to fail or not, if specified will cause test failure when no exceptions were caught and success upon catching any exceptions.
#    * *PRINT_LENGTH* (``int``) -- Optional argument specifying the desired print length of pass/fail output lines.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#
# .. seealso:: :func:`exec_test.cmake.ct_exec_test` for details on halting tests on exceptions.
#
#]]
function(ct_add_section)
    cpp_get_global(_as_curr_exec_unit "CT_CURRENT_EXECUTION_UNIT")
    cpp_get_global(_as_parent_print_length "CMAKETEST_TEST_${_as_curr_exec_unit}_PRINT_LENGTH")
    cpp_get_global(_as_parent_print_length_forced "CMAKETEST_TEST_${_as_curr_exec_unit}_PRINT_LENGTH_FORCED")

    #TODO Set sections as a subproperty of CT_CURRENT_EXECUTION_UNIT instead of as a single global variable
    set(_as_options EXPECTFAIL)
    set(_as_one_value_args NAME PRINT_LENGTH)
    set(_as_multi_value_args "")
    cmake_parse_arguments(CT_ADD_SECTION "${_as_options}" "${_as_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )

    set(_as_print_length_forced "NO")

    #Set default print length to CT_PRINT_LENGTH. Can be overriden with PRINT_LENGTH option to this function or parent execution unit
    set(_as_print_length "${CT_PRINT_LENGTH}")
    if(CT_ADD_SECTION_PRINT_LENGTH GREATER 0)
        set(_as_print_length_forced "YES")
        set(_as_print_length "${CT_ADD_SECTION_PRINT_LENGTH}")
    elseif(_as_parent_print_length_forced)
        set(_as_print_length "${_as_parent_print_length}")
    endif()

    cpp_get_global(_as_curr_section "CMAKETEST_TEST_${_as_curr_exec_unit}_${CT_ADD_SECTION_NAME}_ID")

    cpp_get_global(_as_exec_expectfail "CT_EXEC_EXPECTFAIL") #Unset in main interpreter, TRUE in subprocess


    if(_as_exec_expectfail)
        if("${${CT_ADD_SECTION_NAME}}" STREQUAL "" OR "${${CT_ADD_SECTION_NAME}}" STREQUAL "_")
            set("${CT_ADD_SECTION_NAME}" "_" PARENT_SCOPE)
            return() #If section is not part of the call tree, immediately return
        endif()
    endif()

    if("${${CT_ADD_SECTION_NAME}}" STREQUAL "")
         cpp_unique_id(_as_section_name) #Generate random section ID
         set("${CT_ADD_SECTION_NAME}" "${_as_section_name}") #Need to duplicate because CMake scoping rules are inconsistent. Setting in parent scope does not set in current scope
         set("${CT_ADD_SECTION_NAME}" "${_as_section_name}" PARENT_SCOPE)
    endif()

    cpp_append_global(CMAKETEST_TEST_${_as_curr_exec_unit}_SECTIONS "${${CT_ADD_SECTION_NAME}}")

    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_EXPECTFAIL" "${CT_ADD_SECTION_EXPECTFAIL}") #Set a flag for whether the section is expected to fail or not
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_FRIENDLY_NAME" "${CT_ADD_SECTION_NAME}") #Store the friendly name for the test
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PRINT_LENGTH" "${_as_print_length}") #Store print length in case it's overriden
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PRINT_LENGTH_FORCED" "${_as_print_length_forced}") #Store whether PRINT_LENGTH option was used

    #Store this section's parent and its parents so we can trace the execution path back
    cpp_get_global(_as_parents_parent_tree "CMAKETEST_TEST_${_as_curr_exec_unit}_PARENT_TREE") #Get our parent's parent tree
    if(_as_parents_parent_tree STREQUAL "") #If parent is root test
        set(_as_parents_parent_tree "${_as_curr_exec_unit}") #Set parent tree to root
    endif()
    cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PARENT_TREE" "${_as_parents_parent_tree};${${CT_ADD_SECTION_NAME}}")

    cpp_get_global(_as_test_tree "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PARENT_TREE")

    list(GET _as_test_tree 1 _as_test_tree_first)



    set(_as_original_unit "${_as_curr_exec_unit}")
    cpp_get_global(_as_exec_section "CMAKETEST_TEST_${_as_curr_exec_unit}_EXECUTE_SECTIONS") #Get whether we should execute section now


    if(_as_exec_section) #Time to execute our section


        cpp_get_global(_as_old_section_depth "CMAKETEST_SECTION_DEPTH")
        math(EXPR _as_new_section_depth "${_as_old_section_depth} + 1")
        cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_new_section_depth}")
        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}_${_as_curr_section}")
        cpp_get_global(_as_friendly_name "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_FRIENDLY_NAME")



        cpp_get_global(_as_expect_fail "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXPECTFAIL")
        cpp_get_global(_as_print_length "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PRINT_LENGTH")


        if(_as_expect_fail) #If this section expects to fail

            if(NOT _as_exec_expectfail) #We're in main interpreter so we need to configure and execute the subprocess
                ct_expectfail_subprocess("${_as_curr_exec_unit}" "${_as_curr_section}")
            else() #We're in subprocess
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
           _ct_print_fail("${_as_friendly_name}" "${_as_new_section_depth}" "${_as_print_length}")
           cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
           ct_exit()
       else()
           _ct_print_pass("${_as_friendly_name}" "${_as_new_section_depth}" "${_as_print_length}")
       endif()


       # Get whether this section has subsections, only run again if subsections detected
       cpp_get_global(_as_has_subsections "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_SECTIONS")
       if((NOT _as_has_subsections STREQUAL "") AND ((NOT _as_expect_fail AND NOT _as_exec_expectfail) OR (_as_exec_expectfail))) #If in main interpreter and not expecting to fail OR in subprocess
           #Execute the section again, this time executing subsections. Only do when not executing expectfail
           cpp_set_global("CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXECUTE_SECTIONS" TRUE)
           include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")

      endif()

      cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}")
      cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_old_section_depth}")

      #cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_EXECUTE_SECTIONS" FALSE) #Get whether we should execute section now

    else()
        #First time run, set the ID so we don't lose it on the second run.
        #This will only cause conflicts if two sections in the same test
        #use the same friendly name (the variable used to store the ID and used in the function definition), which no sane programmer would do
        cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_${CT_ADD_SECTION_NAME}_ID" "${${CT_ADD_SECTION_NAME}}")

    endif()

endfunction()
