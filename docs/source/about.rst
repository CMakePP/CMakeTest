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

About CMakeTest
===============

Many languages have unit testing frameworks that can be used for testing code
written in that language. For example Python has the native ``unittest`` module
and C++ has ``Catch2`` and ``GTest`` (among others). To our knowledge no such
unit testing framework exists for CMake (at least that is written in native
CMake) and the CMakeTest project seeks to remedy this.

It should be noted that CMake's ``ctest`` command is **not** a unit testing
framework for CMake code, but rather a means of integrating unit testing into a
CMake build system. Using ``ctest`` is orthogonal to testing CMake modules.

Features
--------

- 100% CMake
   - Integrates naturally into existing CMake scripts
- Integrates with CTest
   - Run build system tests alongside your built project tests
- Scoped subtests
   - Add subsections to your top-level tests to contain related tests together
- Test and section definitions supported in `CMinx <https://github.com/CMakePP/CMinx>`_
   - Document your tests just like you do functions
