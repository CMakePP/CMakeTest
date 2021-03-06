**********************
Testing Error-Checking
**********************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test("Making sure my function fails")

       function(failing_fxn)
           message(FATAL_ERROR "I have erred.")
       endfunction()

       failing_fxn()

       ct_assert_fails_as("I have erred")

   ct_end_test()
