
##############
add_test.cmake
##############

.. module:: add_test.cmake


.. function:: ct_add_test()

   .. warning:: This is a macro, and so does not introduce a new scope.


   Defines a unit test for the CMakeTest framework.

   

   Unit testing in CMakeTest works by reflection. Namely, when the ``cmake``

   executable reads through the unit test the first unit testing command it must

   find is ``ct_add_test`` (finding any other command is an error). When it

   finds the first ``ct_add_test`` the file is read in and parsed. Based on the

   contents of the file ``CMakeLists.txt`` are generated, and then the tests are

   run. That all occurs in the function ``_ct_add_test_guts`` to avoid

   contaminating the testing namespace. Once all that is done we call

   ``return()`` from the ``ct_add_test`` macro, which since it is a macro returns

   from the unit test file without actually running any of the remaining

   commands.

   

   :param _at_test_name: The name of the unit test.

   :type _at_test_name: str

   


.. function:: ct_add_section()

   .. warning:: This is a macro, and so does not introduce a new scope.


   

   Adds a test section, should be called inside of a declared test function directly before declaring the section function.

   The NAME parameter will be populated as by set() with the generated section function name. Declare the section function using this generated name. Ex:

   

   .. code-block:: cmake

   

      #This is inside of a declared test function

      ct_add_section(NAME this_section)

      function(${this_section})

          message(STATUS "This code will run in a test section")

      endfunction()

   

   


.. function:: ct_exec_sections()

   .. warning:: This is a macro, and so does not introduce a new scope.


   

   Execute sections of a test. This will be called directly after running the enclosing test,

   and will execute sections in a subprocess if they are expected to fail.

   .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.

   

