include(cmake_test/cmake_test)

ct_add_test("TestSection Ctor")
    include(cmake_test/detail_/test_section/ctor)

    ct_add_section("Fails if arg1 is empty")
        _ct_test_section_ctor("" "x")
        ct_assert_fails_as("_tsc_handle is empty.")
    ct_end_section()

    ct_add_section("Fails if arg2 is empty")
        _ct_test_section_ctor("x" "")
        ct_assert_fails_as("_tsc_name is empty.")
    ct_end_section()

    ct_add_section("check state")
        _ct_test_section_ctor(result "title")

        ct_add_section("return is handle")
            _ct_is_handle(result)
        ct_end_section()

        ct_add_section("title")
            _ct_get_prop(${result} check "title")
            ct_assert_equal(check "title")
        ct_end_section()

        ct_add_section("content")
            _ct_get_prop(${result} check "content")
            ct_assert_equal(check "")
        ct_end_section()

        ct_add_section("print asserts")
            _ct_get_prop(${result} check "print_assert")
            ct_assert_equal(check "")
        ct_end_section()

        ct_add_section("should_pass")
            _ct_get_prop(${result} check "should_pass")
            ct_assert_equal(check "TRUE")
        ct_end_section()

        ct_add_section("parent_section")
            _ct_get_prop(${result} check "parent_section")
            ct_assert_equal(check "0")
        ct_end_section()

        ct_add_section("printed")
            _ct_get_prop(${result} check "printed")
            ct_assert_equal(check "FALSE")
        ct_end_section()

    ct_end_section()

ct_end_test()
