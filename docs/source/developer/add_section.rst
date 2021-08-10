
#################
add_section.cmake
#################

.. module:: add_section.cmake


.. function:: ct_add_section()

   

   Adds a test section, should be called inside of a declared test function directly before declaring the section function.

   The NAME parameter will be populated as by set() with the generated section function name. Declare the section function using this generated name. Ex:

   

   .. code-block:: cmake

   

      #This is inside of a declared test function

      ct_add_section(NAME this_section)

      function(${this_section})

          message(STATUS "This code will run in a test section")

      endfunction()

   

   Upon being executed, this function will check if the CMAKETEST_TEST_${current_exec_unit}_EXECUTE_SECTIONS CMakePP global is set.

   If it is not, ct_add_section() will generate an ID for the section function and sets the variable pointed to by the NAME parameter to it.

   

   If the flag is set, ct_add_section() will increment the CMAKETEST_SECTION_DEPTH CMakePP global, write a file to the build directory with a line calling the section function,

   and include the file to execute the function. Exceptions will be tracked while the function is being executed. After completion of the test, the test status will be output

   to the screen. The CMAKETEST_TEST_${current_exec_unit}_${section_id}_EXECUTE_SECTIONS flag will then be set. The section function will then be executed again, and

   any subsections will then execute as well, following this same flow until there are no more subsections. Section depth is tracked by the CMAKETEST_SECTION_DEPTH CMakePP global.

   

   If a section raises an exception when it is not expected to, testing will halt immediately. To keep parity between different types of tests, EXPECTFAIL sections that do not raise

   exceptions will also halt all testing.

   

   

   Print length of pass/fail lines can be adjusted with the `PRINT_LENGTH` option.

   

   Priority for print length is as follows (first most important):

    1. Current execution unit's PRINT_LENGTH option

    2. Parent's PRINT_LENGTH option

    3. Length set by ct_set_print_length()

    4. Built-in default of 80.

   

   

   :param **kwargs: See below

   

   :Keyword Arguments:

      * *NAME* (``pointer``) -- Required argument specifying the name variable of the section. Will set a variable with specified name containing the generated function ID to use.

      * *EXPECTFAIL* (``option``) -- Option indicating whether the section is expected to fail or not, if specified will cause test failure when no exceptions were caught and success upon catching any exceptions.

      * *PRINT_LENGTH* (``int``) -- Optional argument specifying the desired print length of pass/fail output lines.

   

   .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.

   

   .. seealso:: :func:`exec_test.cmake.ct_exec_test` for details on halting tests on exceptions.

   

   

