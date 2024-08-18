.. Copyright 2023 CMakePP
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

***************
Basic Unit Test
***************

Below is a basic unit test that simply asserts that
a particular string is printed.

.. literalinclude:: ../../../tests/cmake_test/tutorials/1_hello_world.cmake
   :language: cmake
   :lines: 29-33


The :obj:`~cmake_test/add_test.ct_add_test` call tells CMakeTest that there is a test
with the name :code:`hello_world`. The function definition below it
defines the test. Note the odd :code:`${CMAKETEST_TEST}` as the function name.
This is required to link the function definition with the test. The
value of the implicitly set :code:`CMAKETEST_TEST` variable is a unique
identifier for the test, it's only used internally.

The name of the test may be any string and can include special characters.
If the name has such special characters, pass it as a bracket argument
instead of as a quoted argument.

.. note::
   There is a secondary, deprecated form of naming tests and sections.
   This secondary form has restrictions on the name given such that it
   is a valid CMake variable identifier. New tests and sections should
   use the above form instead. See :obj:`~cmake_test/add_test.ct_add_test`
   for information on the deprecated form.

Inside the function one will notice a call to
:obj:`~cmake_test/asserts/prints.ct_assert_prints`.
This is one of the included assertion functions. If an assertion fails,
the test is stopped and labeled as failing in the output.
Subsequent tests will still be ran.
