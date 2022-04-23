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
    cpp_get_global(_as_curr_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
    CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_print_length print_length)
    CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_print_length_forced print_length_forced)

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

    CTExecutionUnit(GET "${_as_curr_instance}" _as_sibling_sections_map section_names_to_ids)
    cpp_map(GET "${_as_sibling_sections_map}" _as_curr_section_id "${CT_ADD_SECTION_NAME}")

    #Unset in main interpreter, TRUE in subprocess
    cpp_get_global(_as_exec_expectfail "CT_EXEC_EXPECTFAIL")


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



    set(_as_original_unit_instance "${_as_curr_instance}")

    #Get whether we should execute section now
    CTExecutionUnit(GET "${_as_curr_instance}" _as_exec_section execute_sections)
    CTExecutionUnit(GET "${_as_curr_instance}" _as_has_executed has_executed)

    if(_as_exec_section AND NOT _as_has_executed) #Time to execute our section
        #Factor back out into exec_section()
        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_children children)
        cpp_map(GET "${_as_parent_children}" _as_curr_section_instance "${_as_curr_section_id}")

        cpp_get_global(_as_old_section_depth "CMAKETEST_SECTION_DEPTH")
        math(EXPR _as_new_section_depth "${_as_old_section_depth} + 1")
        cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_new_section_depth}")
        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${_as_curr_section_instance}")

        CTExecutionUnit(GET "${_as_curr_section_instance}" _as_friendly_name friendly_name)


        CTExecutionUnit(GET "${_as_curr_section_instance}" _as_expect_fail expect_fail)
        CTExecutionUnit(GET "${_as_curr_section_instance}" _as_print_length print_length)


        if(_as_expect_fail) #If this section expects to fail

            if(NOT _as_exec_expectfail) #We're in main interpreter so we need to configure and execute the subprocess
                ct_expectfail_subprocess("${_as_curr_section_instance}")
            else() #We're in subprocess
                file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section_id}.cmake" "${_as_curr_section_id}()")
                include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section_id}.cmake")
                CTExecutionUnit(GET "${_as_curr_section_instance}" _as_exceptions exceptions)

                if(NOT "${_as_exceptions}" STREQUAL "")
                    foreach(_as_exc IN LISTS _as_exceptions)
                        message("${CT_BoldRed}Section named \"${_as_friendly_name}\" raised exception:")
                        message("${_as_exc}${CT_ColorReset}")
                    endforeach()
                    set(_as_section_fail "TRUE")
               endif()
           endif()

        else()
            file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section_id}.cmake" "${_as_curr_section_id}()")
            include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section_id}.cmake")
            CTExecutionUnit(GET "${_as_curr_section_instance}" _as_exceptions exceptions)

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

           #At least one test failed, so we will inform the caller that not all tests passed.
           cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE")
           ct_exit()
       else()
           _ct_print_pass("${_as_friendly_name}" "${_as_new_section_depth}" "${_as_print_length}")
       endif()


       # Get whether this section has subsections, only run again if subsections detected
       CTExecutionUnit(GET "${_as_curr_section_instance}" _as_children_map children)
       cpp_map(KEYS "${_as_children_map}" _as_has_subsections)
       if((NOT _as_has_subsections STREQUAL "") AND ((NOT _as_expect_fail AND NOT _as_exec_expectfail) OR (_as_exec_expectfail))) #If in main interpreter and not expecting to fail OR in subprocess
           #Execute the section again, this time executing subsections. Only do when not executing expectfail
           CTExecutionUnit(SET "${_as_curr_section_instance}" execute_sections TRUE)
           include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section_id}.cmake")

      endif()

      CTExecutionUnit(SET "${_as_curr_section_instance}" has_executed TRUE)

      cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${_as_original_unit_instance}")
      cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_old_section_depth}")

    else()
        #First time run, set the ID so we don't lose it on the second run.
        #This will only cause conflicts if two sections in the same test
        #use the same friendly name (the variable used to store the ID and used in the function definition), which no sane programmer would do

        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_file test_file)

        CTExecutionUnit(CTOR _as_new_section "${${CT_ADD_SECTION_NAME}}" "${CT_ADD_SECTION_NAME}" "${CT_ADD_SECTION_EXPECTFAIL}")
        CTExecutionUnit(SET "${_as_new_section}" parent "${_as_curr_instance}")
        CTExecutionUnit(SET "${_as_new_section}" print_length_forced "${_as_print_length_forced}")
        CTExecutionUnit(SET "${_as_new_section}" print_length "${_as_print_length}")
        CTExecutionUnit(SET "${_as_new_section}" test_file "${_as_parent_file}")
        CTExecutionUnit(append_child "${_as_curr_instance}" "${${CT_ADD_SECTION_NAME}}" "${_as_new_section}")
        CTExecutionUnit(GET "${_as_curr_instance}" _as_siblings section_names_to_ids)
        cpp_map(SET "${_as_siblings}" "${CT_ADD_SECTION_NAME}" "${${CT_ADD_SECTION_NAME}}")

    endif()

endfunction()
