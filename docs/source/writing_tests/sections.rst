********************
Sections (Sub-Tests)
********************

.. code-block:: cmake

   include(cmake_test/cmake_test)

   ct_add_test("My Second Test!!!")

       set(foo bar)

       ct_add_section("A sub-test")
           set(foo baz)
           ct_assert_equal(foo "baz")
       ct_end_section()

       ct_assert_equal(foo "bar")

   ct_end_test()
