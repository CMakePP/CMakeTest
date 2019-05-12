#TUTORIAL
#
# All CMake unit testing machinery is included in the CmakeTest module.
# Assuming the path to that module is part of your ``CMAKE_MODULE_PATH``, all
# you need to do to use CMakeTest is include the ``cmake_test/cmake_test.cmake``
# in your unit test (since it's in your ``CMAKE_MODULE_PATH``, you don't put the
# ".cmake" extension).
include(cmake_test/cmake_test)

#TUTORIAL
#
# Unit tests in CMakeTest mirror the Catch2 unit-testing philosophy. For our
# present tutorial know that this means that your unit tests must be inside a
# ``ct_add_test`` section. The section header takes one required argument, the
# name of the test.
ct_add_test("Hello World")

    #TUTORIAL
    #
    # The content between ``ct_add_test`` and ``ct_end_test`` comprise the body
    # of this unit test. They will be a mix of the CMake code you are testing and
    # CMakeTest directives. For now we write a simle unit test that simply prints
    # "Hello World" and verifies that it was printed.
    message("Hello World")

    #TUTORIAL
    #
    # CMakeTest comes with a variety of asserts. Asserts are the criteria that
    # your unit test must pass in order to be deemed sucessful. We'll get into
    # the available asserts in a later tutorial, for now we simply introduce the
    # ``ct_assert_prints`` assert. ``ct_assert_prints`` takes one argument, the
    # the output that the unit test must print, and crashes the test if that
    # output does not appear in the log.
    ct_assert_prints("Hello World")

#TUTORIAL
#
# Finally, when we are done writing the unit test we end it with
# ``ct_end_test``. You can think of ``ct_add_test`` and ``ct_end_test`` as being
# analogous to CMake's native ``if`` and ``endif`` commands, namely they declare
# a logical block.
ct_end_test()
