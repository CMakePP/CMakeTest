cmake_test
==========

This directory contains the content of the CMakeTest module. The actual module
relies on a number of submodules, which are split among the subdirectories and
files.

- `asserts` : contains modules that implement CMakeTest's unit testing asserts
- `detail_` : Contents of this directory are not part of the public API and are
              purely for use in implementing CMakeTest.
- `add_test.cmake` : Defines the programmatic entry point into CMakeTest.
- `cmake_test.cmake` : The API between normal CMake and CMakeTest
