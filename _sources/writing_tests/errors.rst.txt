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

**********************
Testing Error-Checking
**********************

Sometimes one may want to ensure that an exception (or :code:`FATAL_ERROR`)
is thrown, but normally doing so would cause a test to fail. However, there
exists an option to invert the test so that it will only pass if an
exception or :code:`FATAL_ERROR` is thrown. This option is called
:code:`EXPECTFAIL` and the test maker must pass this option
to the :code:`ct_add_test()` or :code:`ct_add_section()` calls
that define the test. An example is below:

.. literalinclude:: ../../../tests/cmake_test/expectfail.cmake
   :language: cmake


When using CMinx to document a test, the :code:`EXPECTFAIL`
option will be listed in the test definition.

----------------------
Implementation Details
----------------------
Due to limitations in the CMake language, CMakeTest must run
:code:`EXPECTFAIL` tests in a subprocess. This introduces significant
latency in executing such tests. If performance becomes a problem try
splitting some tests into different files and use CTest's :code:`-j`
option to run more processes at once.