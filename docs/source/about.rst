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

- 100% CMake (non-CMake files in this repo are for generating documentation)
   - Integrates naturally into existing CMake scripts
- Integrates with CTest
   - Run build system tests alongside your built project tests
- Scoped subtests
   - Add subsections to your top-level tests to contain related tests together
- Test and section definitions supported in `CMinx <https://github.com/CMakePP/CMinx>`_
   - Document your tests just like you do functions
