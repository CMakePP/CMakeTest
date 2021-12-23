# CMakeTest

![](https://github.com/CMakePP/CMakeTest/workflows/CMakeTest%20CI/badge.svg)

CMake ships with `ctest` which helps integrate your project's tests into your
project's build system. `ctest`, is a powerful solution for managing your
project's tests, but it is designed to be decoupled from the framework used to
actually test the code. Thus for CMake development purposes we still need a
testing framework to ensure our CMake modules behave correctly. That is where
CMakeTest comes in.

CMakeTest is modeled after the Catch2 testing framework for C++. CMakeTest is a
CMake module, written 100% in CMake. Unit testing with CMakeTest relies on the
use of `ct_add_test` and `ct_add_section` special declarations, followed by `function`
blocks. Within these blocks users write their unit tests in native CMake;
no need for ugly escapes or workarounds. The user then relies on assertions
provided by CMakeTest to ensure that the program has the expected state. For
example we can ensure that a CMake code sets a particular variable using
`ct_assert_equal`. This looks like:

```.cmake
include(cmake_test/cmake_test)
ct_add_test(NAME "_first_test")
function(${_first_test})
    set(hello_world "Hello World!!!")
    ct_assert_equal(hello_world "Hello World!!!")
endfunction()
```
