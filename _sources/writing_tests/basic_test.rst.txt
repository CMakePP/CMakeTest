***************
Basic Unit Test
***************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test("My First Test!!!")

       set(foo bar)
       ct_assert_equal(foo "bar")

   ct_end_test()
