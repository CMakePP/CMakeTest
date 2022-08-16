***************
Basic Unit Test
***************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test(NAME "my_first_test")
   function("${my_fist_test}")

       set(foo bar)
       ct_assert_equal(foo "bar")

   endfunction()
