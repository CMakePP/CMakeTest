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
# Upon being executed, this function will check if the section should be executed.
# If it is not, ct_add_section() will generate an ID for the section function and sets the variable pointed to by the NAME parameter to it.
# It will also construct a new CTExecutionUnit instance to represent the section.
#
# If the section is supposed to be executed, ct_add_section() will call the ``execute`` member function of the CTExecutionUnit representing this section.
# Exceptions will be tracked while the function is being executed. After completion of the test, the test status will be output
# to the screen. The section subsections will then be executed, following this same flow until there are no more subsections.
#
# If a section raises an exception when it is not expected to, it will be marked as a failing section and its subsections
# will not be executed, due to limitations in how CMake handles failures. However, sibling sections as well as 
# other tests will continue to execute, and the failures will be aggregated and printed after all tests have been ran.
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

    #Get whether we should execute section now
    CTExecutionUnit(GET "${_as_curr_instance}" _as_exec_section execute_sections)

    if(_as_exec_section) #Time to execute our section
        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_children children)
        cpp_map(GET "${_as_parent_children}" _as_curr_section_instance "${_as_curr_section_id}")

        CTExecutionUnit(execute "${_as_curr_section_instance}")
    else()
        #First time run, construct and configure
        #the new section unit, as well as add it
        #to its parent

        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_file test_file)
        CTExecutionUnit(GET "${_as_curr_instance}" _as_parent_section_depth section_depth)
        
        math(EXPR _as_new_section_depth "${_as_parent_section_depth} + 1")

        CTExecutionUnit(CTOR _as_new_section "${${CT_ADD_SECTION_NAME}}" "${CT_ADD_SECTION_NAME}" "${CT_ADD_SECTION_EXPECTFAIL}")
        CTExecutionUnit(SET "${_as_new_section}" parent "${_as_curr_instance}")
        CTExecutionUnit(SET "${_as_new_section}" print_length_forced "${_as_print_length_forced}")
        CTExecutionUnit(SET "${_as_new_section}" print_length "${_as_print_length}")
        CTExecutionUnit(SET "${_as_new_section}" test_file "${_as_parent_file}")
        CTExecutionUnit(SET "${_as_new_section}" section_depth "${_as_new_section_depth}")
        CTExecutionUnit(append_child "${_as_curr_instance}" "${${CT_ADD_SECTION_NAME}}" "${_as_new_section}")
        CTExecutionUnit(GET "${_as_curr_instance}" _as_siblings section_names_to_ids)
        cpp_map(SET "${_as_siblings}" "${CT_ADD_SECTION_NAME}" "${${CT_ADD_SECTION_NAME}}")

    endif()

endfunction()
