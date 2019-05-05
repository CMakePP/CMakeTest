include(cmake_test/cmake_test)

ct_add_test("Hello World")
    ct_add_section("Can Print Hello World")
        message("Hello World")
        ct_assert_prints("Hello World")
    ct_end_section()
ct_end_test()
