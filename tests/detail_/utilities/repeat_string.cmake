include(cmake_test/cmake_test)

ct_add_test("repeat_string")
    include(cmake_test/detail_/utilities/repeat_string)

    ct_add_section("empty string")
        _ct_repeat_string(result "" 4)
        ct_assert_equal(result "")
    ct_end_section()

    ct_add_section("Repeat 0 times")
        _ct_repeat_string(result "x" 0)
        ct_assert_equal(result "")
    ct_end_section()

    ct_add_section("Single character")
        _ct_repeat_string(result "x" 4)
        ct_assert_equal(result "xxxx")
    ct_end_section()

    ct_add_section("Substring")
        _ct_repeat_string(result "xy" 4)
        ct_assert_equal(result "xyxyxyxy")
    ct_end_section()
ct_end_test()
