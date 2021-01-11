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
#
# :param **kwargs: See below
#
# :Keyword Arguments:
#    * *NAME* (``pointer``) -- Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.
#    * *EXPECTFAIL* (``option``) -- Option indicating whether the section is expected to fail or not, if specified will cause test failure when no exceptions were caught and success upon catching any exceptions.
#
#]]
macro(ct_add_test)
    cpp_get_global(_at_exec_unit "CT_CURRENT_EXECUTION_UNIT")
    cpp_get_global(_at_exec_expectfail "CT_EXEC_EXPECTFAIL") #Unset in main interpreter, TRUE in subprocess

    if(NOT ("${_at_exec_unit}" STREQUAL "") AND NOT _at_exec_expectfail)
        cpp_get_global(_at_exec_unit_friendly_name "CMAKETEST_TEST_${_at_exec_unit}_FRIENDLY_NAME")
        ct_exit("ct_add_test() encountered while executing a CMakeTest test or section named \"${_at_exec_unit_friendly_name}\"")
    endif()



    set(_at_options EXPECTFAIL)
    set(_at_one_value_args NAME)
    set(_at_multi_value_args "")
    cmake_parse_arguments(CT_ADD_TEST "${_at_options}" "${_at_one_value_args}"
                          "${_at_multi_value_args}" ${ARGN} )

    if("${${CT_ADD_TEST_NAME}}" STREQUAL "")
         cpp_unique_id("${CT_ADD_TEST_NAME}") #Randomized identifier, only alphabetical characters so it generates a valid identifier.
    endif()

    cpp_append_global("CMAKETEST_TESTS" "${${CT_ADD_TEST_NAME}}")

    cpp_set_global("CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}") #Mark the test as expecting to fail or not
    cpp_set_global("CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_FRIENDLY_NAME" "${CT_ADD_TEST_NAME}") #Store the friendly name for the test
    cpp_set_global("CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_FILE" "${CMAKE_CURRENT_LIST_FILE}") #Store the file location for when we need to re-execute in subprocess

    message("Test w/ friendly name \"${CT_ADD_TEST_NAME}\" has ID \"${${CT_ADD_TEST_NAME}}\" and file \"${CMAKE_CURRENT_LIST_FILE}\"")
endmacro()




