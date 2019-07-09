include(cmake_test/cmake_test)

ct_add_test("sanitize_name")
    include(cmake_test/detail_/utilities/sanitize_name)

    ct_add_section("already good")
        _ct_sanitize_name(result "already_good")
        ct_assert_equal(result "already_good")
    ct_end_section()

    ct_add_section("makes it lowercase")
        _ct_sanitize_name(result "SCREAMING")
        ct_assert_equal(result "screaming")
    ct_end_section()

    ct_add_section("replaces spaces")
        _ct_sanitize_name(result "has two spaces")
        ct_assert_equal(result "has_two_spaces")
    ct_end_section()

    ct_add_section("replaces colons")
        _ct_sanitize_name(result "has:")
        ct_assert_equal(result "has-")
    ct_end_section()
ct_end_test()
