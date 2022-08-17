********************
Sections (Sub-Tests)
********************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test(NAME "my_second_test")
   function("${my_second_test}")

       set(foo bar)
       ct_assert_equal(foo "bar")

       ct_add_section("subtest")
       function("${subtest}")
           set(foo baz)
           ct_assert_equal(foo "baz")
       endfunction()

   endfunction()
