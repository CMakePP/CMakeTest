include_guard()
include(cmake_test/detail_/add_test)

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
# :type _at_test_name: string
#]]
macro(ct_add_test _at_test_name)
    _ct_add_test_guts("${_at_test_name}")
    return()
endmacro()
