
CMakeTest
=========


.. image:: https://github.com/CMakePP/CMakeTest/workflows/CMakeTest%20CI/badge.svg
   :target: https://github.com/CMakePP/CMakeTest/workflows/CMakeTest%20CI/badge.svg
   :alt: 


CMake ships with ``ctest`` which helps integrate your project's tests into your
project's build system. ``ctest``\ , is a powerful solution for managing your
project's tests, but it is designed to be decoupled from the framework used to
actually test the code. Thus for CMake development purposes we still need a
testing framework to ensure our CMake modules behave correctly. That is where
CMakeTest comes in.

CMakeTest is modeled after the Catch2 testing framework for C++. CMakeTest is a
CMake module, written 100% in CMake. Unit testing with CMakeTest relies on the
use of ``ct_add_test`` and ``ct_add_section`` special declarations, followed by ``function``
blocks. Within these blocks users write their unit tests in native CMake;
no need for ugly escapes or workarounds. The user then relies on assertions
provided by CMakeTest to ensure that the program has the expected state. For
example we can ensure that a CMake code sets a particular variable using
``ct_assert_equal``. This looks like:

.. code-block:: .cmake

   include(cmake_test/cmake_test)
   ct_add_test(NAME "_first_test")
   function(${_first_test})
       set(hello_world "Hello World!!!")
       ct_assert_equal(hello_world "Hello World!!!")
   endfunction()

Installation
------------
CMakeTest can be installed via :code:`FetchContent` or by manually placing the
:code:`cmake_test` directory on your :code:`CMAKE_MODULES_PATH`.

The following CMake code allows one to install CMakeTest via FetchContent:

.. code-block:: cmake

   include_guard()

   #[[[
   # This function encapsulates the process of getting CMakeTest using CMake's
   # FetchContent module. We have encapsulated it in a function so we can set
   # the options for its configure step without affecting the options for the
   # parent project's configure step (namely we do not want to build CMakeTest's
   # unit tests).
   #]]
   macro(get_cmake_test)
       include(cmake_test/cmake_test OPTIONAL RESULT_VARIABLE cmake_test_found)
       if(NOT cmake_test_found)



           # Store whether we are building tests or not, then turn off the tests
           set(build_testing_old "${BUILD_TESTING}")
           set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
           # Download CMakeTest and bring it into scope
           include(FetchContent)
           FetchContent_Declare(
                cmake_test
                GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
          )
          FetchContent_MakeAvailable(cmake_test)

          # Restore the previous value
          set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
       endif()
   endmacro()

   # Call the function we just wrote to get CMakeTest
   get_cmake_test()

   # Include CMakeTest
   include(cmake_test/cmake_test)

Documentation and Tutorials
---------------------------
Documentation can be found `here <https://cmakepp.github.io/CMakeTest/>`_
