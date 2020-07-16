include_guard()

#[[[ Defines a unit test for the CMakeTest framework.
#
# Unit testing in CMakeTest works by reflection. Namely, when the ``cmake``
# executable reads through the unit test the first unit testing command it must
# find is ``ct_add_test`` (finding any other command is an error). When it
# finds the first ``ct_add_test`` the file is read in and parsed. Based on the
# contents of the file ``CMakeLists.txt`` are generated, and then the tests are
# run. That all occurs in the function ``_ct_add_test_guts`` to avoid
# contaminating the testing namespace. Once all that is done we call
# ``return()`` from the ``ct_add_test`` macro, which since it is a macro returns
# from the unit test file without actually running any of the remaining
# commands.
#
# :param _at_test_name: The name of the unit test.
# :type _at_test_name: str
#]]
macro(ct_add_test)

    set(_at_options EXPECTFAIL)
    set(_at_one_value_args NAME)
    set(_as_multi_value_args "")
    cmake_parse_arguments(CT_ADD_TEST "${_at_options}" "${_at_one_value_args}"
                          "${_as_multi_value_args}" ${ARGN} )

    #[[_ct_add_test_guts("${_at_test_name}")
    #return()
    #]]

    string(RANDOM ALPHABET "abcdefghijklmnopqrstuvwxyz" "${CT_ADD_TEST_NAME}") #Randomized identifier, only alphabetical characters so it generates a valid identifier.
    get_property(_at_curr_tests GLOBAL PROPERTY "CMAKETEST_TEST_TESTS")

    list(APPEND _at_curr_tests "${${CT_ADD_TEST_NAME}}") #Add the test ID to the list of tests being executed
    set_property(GLOBAL PROPERTY "CMAKETEST_TEST_TESTS" "${_at_curr_tests}") #Update the global list of tests


    set_property(GLOBAL PROPERTY "CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_EXPECTFAIL" "${CT_ADD_TEST_EXPECTFAIL}") #Mark the test as expecting to fail or not
    set_property(GLOBAL PROPERTY "CMAKETEST_TEST_${${CT_ADD_TEST_NAME}}_FRIENDLY_NAME" "${CT_ADD_TEST_NAME}") #Store the friendly name for the test
endmacro()




