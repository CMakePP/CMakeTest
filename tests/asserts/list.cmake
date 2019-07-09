include(cmake_test/cmake_test)

ct_add_test("assert_list")
    include(cmake_test/asserts/list)

    ct_add_section("Empty string")
        set(input "")
        ct_assert_list(input)
        ct_assert_fails_as("input is not a list.  Contents:")
    ct_end_section()

    ct_add_section("string")
        set(input "hi")
        ct_assert_list(input)
        ct_assert_fails_as("input is not a list.  Contents: hi")
    ct_end_section()

    ct_add_section("Escaped semicolon")
        set(input "hi\;world")
        ct_assert_list(input)
        ct_assert_fails_as("input is not a list.  Contents:")
    ct_end_section()

    ct_add_section("A hard-coded list")
        set(input "hi;world")
        ct_assert_list(input)
    ct_end_section()

    ct_add_section("An implicit list")
        set(input "hi" "world")
        ct_assert_list(input)
    ct_end_section()
ct_end_test()

ct_add_test("assert_not_list")
    include(cmake_test/asserts/list)

    ct_add_section("Empty string")
        set(input "")
        ct_assert_not_list(input)
    ct_end_section()

    ct_add_section("string")
        set(input "hi")
        ct_assert_not_list(input)
    ct_end_section()

    ct_add_section("Escaped semicolon")
        set(input "hi\;world")
        ct_assert_not_list(input)
    ct_end_section()

    ct_add_section("A hard-coded list")
        set(input "hi;world")
        ct_assert_not_list(input)
        ct_assert_fails_as("input is list: hi")
    ct_end_section()

    ct_add_section("An implicit list")
        set(input "hi" "world")
        ct_assert_not_list(input)
        ct_assert_fails_as("input is list: hi")
    ct_end_section()
ct_end_test()
