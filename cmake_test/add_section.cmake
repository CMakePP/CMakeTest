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
# :param EXPECTFAIL: Option indicating whether the section is expected to fail or not, if specified will cause the section to be ran in a subprocess.
# :param NAME name: Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.
#]]
macro(ct_add_section)

    #TODO Set sections as a subproperty of CT_CURRENT_EXECUTION_UNIT instead of as a single global variable
    set(_as_options EXPECTFAIL)
    set(_as_one_value_args NAME)
    set(_as_multi_value_args "")
    cmake_parse_arguments(CT_ADD_SECTION "${as_options}" "${as_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    string(RANDOM ALPHABET "abcdefghijklmnopqrstuvwxyz" "${CT_ADD_SECTION_NAME}") #Generate random section ID, using only alphabetical characters
    get_property(_as_curr_exec_unit GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
    get_property(_as_curr_sections GLOBAL PROPERTY "CMAKETEST_TEST_${curr_exec_unit}_SECTIONS")
    list(APPEND _as_curr_sections "${${CT_ADD_SECTION_NAME}}")
    set_property(GLOBAL PROPERTY CMAKETEST_TEST_${_as_curr_exec_unit}_SECTIONS "${_as_curr_sections}") #Append the section ID to the list of sections, since this will be executed in the test's scope we need to set it in pare>
    #message(STATUS "Adding section: ${CT_ADD_SECTION_NAME}")
    set_property(GLOBAL PROPERTY "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_EXPECTFAIL" "${CT_ADD_SECTION_EXPECTFAIL}") #Set a flag for whether the section is expected to fail or not
    set_property(GLOBAL PROPERTY "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_FRIENDLY_NAME" "${CT_ADD_SECTION_NAME}") #Store the friendly name for the test

endmacro()
