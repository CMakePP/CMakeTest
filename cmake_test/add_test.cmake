include_guard()

#[[[ Defines a unit test for the CMakeTest framework.
#
# Unit testing in CMakeTest works by `include()`ing each unit test, determining which ones
# need to be ran, and then executing them sequentially in-process. This macro defines which functions
# are to be interpretted as actual unit tests. It does so by setting a variable in the calling scope
# that is to be used as the function identifier. For example:
#
# .. code-block:: cmake
#
#    ct_add_test(NAME this_test)
#    function(${this_test})
#        message(STATUS "This code will run in a unit test")
#    endfunction()
#
# This helps tests avoid name collisions and also allows the testing framework to keep track of them.
#]]
macro(ct_add_test)
    cpp_get_global(_at_exec_unit "CT_CURRENT_EXECUTION_UNIT")
    #message("${_at_exec_unit}")
    if(NOT ("${_at_exec_unit}" STREQUAL ""))
        cpp_get_global(_at_exec_unit_friendly_name "CMAKETEST_TEST_${_at_exec_unit}_FRIENDLY_NAME")
        ct_exit("ct_add_test() encountered while executing a CMakeTest test or section named \"${_at_exec_unit_friendly_name}\"")
    endif()


    set(_at_options EXPECTFAIL)
    set(_at_one_value_args NAME)
    set(_as_multi_value_args "")
    cmake_parse_arguments(CT_ADD_TEST "${_at_options}" "${_at_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    cpp_unique_id("${CT_ADD_TEST_NAME}") #Randomized identifier, only alphabetical characters so it generates a valid identifier.
    #get_property(_at_curr_tests GLOBAL PROPERTY "CMAKETEST_TESTS")

    #list(APPEND _at_curr_tests "${${CT_ADD_TEST_NAME}}") #Add the test ID to the list of tests being executed
    #set_property(GLOBAL PROPERTY "CMAKETEST_TESTS" "${_at_curr_tests}") #Update the global list of tests
    cpp_append_global("CMAKETEST_TESTS" "${${CT_ADD_TEST_NAME}}")

    cpp_set_global("CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}") #Mark the test as expecting to fail or not
    cpp_set_global("CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_FRIENDLY_NAME" "${CT_ADD_TEST_NAME}") #Store the friendly name for the test
endmacro()




