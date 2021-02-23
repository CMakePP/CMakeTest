cmake_test
==========

This directory contains the content of the CMakeTest module. The actual module
relies on a number of submodules, which are split among the subdirectories and
files.

- `asserts` : contains modules that implement CMakeTest's unit testing asserts
- `detail_` : Contents of this directory are not part of the public API and are
              purely for use in implementing CMakeTest.
- `templates` : Contains CMake template files that are configured to provide
                necessary boilerplate for CTest and CMake.
- `add_test.cmake` : Defines the programmatic entry point for CMakeTests..
- `add_section.cmake` : Defines the entry point for subsections within tests.
- `add_dir.cmake` : Convenience function for adding an entire directory of tests to CTest.
- `cmake_test.cmake` : The API between normal CMake and CMakeTest
- `colors.cmake` : Defines constants for outputting colors on ANSI-supported terminals.
- `exec_tests.cmake` : Entrypoint into test execution within CTest during the Testing phase.
- `overrides.cmake` : Overrides `message()` to store information used within tests.
                      Also provides `ct_exit()` to force interpreter shutdown.
- `register_exception_handler.cmake` : Defines function for CMakeTest's exception handler.
