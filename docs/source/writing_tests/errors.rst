**********************
Testing Error-Checking
**********************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test(NAME "make_sure_function_fails" EXPECTFAIL)
   function("${make_sure_function_fails}")

       function(failing_fxn)
           message(FATAL_ERROR "I have erred.")
       endfunction()

       failing_fxn()

   endfunction()
