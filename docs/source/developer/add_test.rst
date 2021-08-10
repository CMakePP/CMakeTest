
##############
add_test.cmake
##############

.. module:: add_test.cmake


.. function:: ct_add_test()

   .. warning:: This is a macro, and so does not introduce a new scope.


   Defines a unit test for the CMakeTest framework.

   

   Unit testing in CMakeTest works by `include()`ing each unit test, determining which ones

   need to be ran, and then executing them sequentially in-process. This macro defines which functions

   are to be interpretted as actual unit tests. It does so by setting a variable in the calling scope

   that is to be used as the function identifier. For example:

   

   .. code-block:: cmake

   

      ct_add_test(NAME this_test)

      function(${this_test})

          message(STATUS "This code will run in a unit test")

      endfunction()

   

   This helps tests avoid name collisions and also allows the testing framework to keep track of them.

   

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

   

   

