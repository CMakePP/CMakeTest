include(cmake_test/cmake_test)

ct_add_test("lc_find")
    include(cmake_test/detail_/utilities/lc_find)

    ct_add_section("String not present")
        _ct_lc_find(result "not there" "hello world")
        ct_assert_equal(result "FALSE")
    ct_end_section()

    ct_add_section("String present with same case")
        _ct_lc_find(result "lo wo" "hello world")
        ct_assert_equal(result "TRUE")
    ct_end_section()

    ct_add_section("String present with different case")
        _ct_lc_find(result "Lo WO" "HeLlO woRlD")
        ct_assert_equal(result "TRUE")
    ct_end_section()
ct_end_test()
