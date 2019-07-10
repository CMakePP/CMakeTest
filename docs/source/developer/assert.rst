Adding a New Assert
===================

This page walks you through the process of adding a new assert to CMakeTest.

In order for your assert to be picked up by CMakeTest it must be named starting
with ``ct_assert``. Source code for most asserts (the exceptions are asserts
requiring the CMakeTest driver to parse the arguments to the assert) lives in
``cmake_test/asserts``. Each assert is subject to the usual CMakePP project
coding conventions (*e.g.*, namespace protect variables, document function,
*etc.*).
