***************
Basic Unit Test
***************

Below is a basic unit test that simply asserts that
a particular string is printed.

.. literalinclude:: ../../../tests/tutorials/1_hello_world.cmake
   :language: cmake
   :lines: 23-28


The :obj:`~cmake_test/add_test.ct_add_test` call tells CMakeTest that there is a test
with the name :code:`hello_world`. The function definition below it
defines the test. Note the odd :code:`${hello_world}` used as the
function name. This is required to link the function definition with
the :code:`ct_add_test()` call. :code:`ct_add_test()` takes the test name
and assigns a unique identifier to it to keep track of the accompanying
definition. Thus, if you use the same name for multiple tests in the same
scope they will conflict.

Inside the function one will notice a call to
:obj:`~cmake_test/asserts/prints.ct_assert_prints`.
This is one of the included assertion functions. If an assertion fails,
the test is stopped and labeled as failing in the output.
Subsequent tests will still be ran.