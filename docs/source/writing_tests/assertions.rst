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

.. _Assertions:

##########
Assertions
##########

CMakeTest ships with a wide variety of
assertion commands to assist test makers.
These assertions function similarly to assertions
in other test frameworks, where the test calls
an assertion function that checks its inputs against
a condition. If the assertion fails, the test is halted
and is labeled as failing.

These assertions are only guaranteed to function inside
of CMakeTest tests and sections. For more general purpose
assertions, our sister project
`CMakePPLang <https://github.com/CMakePP/CMakePPLang>`_ has
assertions, which can be found
`here. <https://cmakepp.github.io/CMakePPLang/developer/cmakepp_lang/asserts/index.html>`_

The following assertions are available:

.. toctree::
   :maxdepth: 3

   ../developer/cmake_test/asserts/index