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