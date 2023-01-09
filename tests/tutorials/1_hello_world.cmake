#TUTORIALprint 'hello world!'
#
#To use CMakeTest in your CMake project first ensure that the path to the
#directory containing ``cmake_test/cmake_test.cmake`` is part of your
#``CMAKE_MODULE_PATH``. Then include the following snipppet in your
#``CMakeLists.txt`` file.
include(cmake_test/cmake_test)

#TUTORIAL
#
#After including the main ``cmake_test/cmake_test.cmake`` CMake module you have
#access to all of the CMakeTest machinery. The testing philosophy of CMakeTest
#closely follows that of the Catch2 C++ unit testing framework. In particular
#this means each of your unit tests must be contained within an ``add_test``
#block. The block starts with ``ct_add_test(<test_name>)`` and ends with
#``ct_end_test()`` (all CMakeTest functions are namespaced with a prefix ``ct_``
#to mitigate against collisions with similarly named functions from other
#modules). ``ct_add_test`` and ``ct_end_test`` define a block scope. The CMake
#code in this block scope will serve as the contents of the unit test.
#
#As an introductory example we write a simple unit test that prints
#"Hello World" and asserts that "Hello World" was indeed printed.
ct_add_test(NAME hello_world)
function(${hello_world})
    message("Hello World")
    ct_assert_prints("Hello World")
endfunction()

#TUTORIAL
#
#The contents of the unit test are two commands: ``message("Hello World")`` and
#``ct_assert_prints("Hello World")``. ``message("Hello World")`` simply runs the
#normal, CMake-native ``message`` command. ``ct_assert_prints`` is defined by
#CMakeTest and asserts that after running the unit test the log file must
#contain the text "Hello World". CMakeTest ships with a number of asserts that
#you can use in unit testing your code, which will be introduced in the
#subsequent tutorials.

#TUTORIAL
#Once you have your tests written, we need to generate CTest bootstrap files.
#This should be done by adding a :code:`ct_add_dir()` call to your ``CMakeLists.txt``.
#This call should only be executed when tests are supposed to be built, by convention
#this means checking for the :code:`BUILD_TESTING` option. It's often a good idea to separate test
#configuration from your main ``CMakeLists.txt`` by making a secondary file in your tests directory
#and using :code:`include()` to run it.
#
#When you have your bootstrap files generated a simple :code:`ctest` command should execute them all.
#By default only the pass/fail status of the entire test file is shown, if you wish to view the pass/fail
#status of any test as well as any messages printed use the :code:`-VV` option for ctest.
