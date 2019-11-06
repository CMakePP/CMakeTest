test_section
============

This directory contains the source code for the `TestSection` "class". Each
function's implementation is separated into its own CMake file. To use the
TestSection class from outside the class, it suffices to include
`cmake_test/detail_/test_section/test_section.cmake` in your CMake module and to
go through the API provided by it.
