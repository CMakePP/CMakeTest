include(cmake_test/cmake_test)

ct_add_test("assert_string")
    include(cmake_test/asserts/string)

    ct_add_section("Empty string")
        set(input "")
        ct_assert_string(input)
    ct_end_section()

    ct_add_section("string")
        set(input "hi")
        ct_assert_string(input)
    ct_end_section()

    ct_add_section("Escaped semicolon")
        set(input "hi\;world")
        ct_assert_string(input)
    ct_end_section()

    ct_add_section("A hard-coded list")
        set(input "hi;world")
        ct_assert_string(input)
        ct_assert_fails_as("input is list:")
    ct_end_section()

    ct_add_section("An implicit list")
        set(input "hi" "world")
        ct_assert_string(input)
        ct_assert_fails_as("input is list:")
    ct_end_section()
ct_end_test()

ct_add_test("assert_not_string")
    include(cmake_test/asserts/string)

    ct_add_section("Empty string")
        set(input "")
        ct_assert_not_string(input)
        ct_assert_fails_as("input is string:")
    ct_end_section()

    ct_add_section("string")
        set(input "hi")
        ct_assert_not_string(input)
        ct_assert_fails_as("input is string: hi")
    ct_end_section()

    ct_add_section("Escaped semicolon")
        set(input "hi\;world")
        ct_assert_not_string(input)
        ct_assert_fails_as("input is string:")
    ct_end_section()

    ct_add_section("A hard-coded list")
        set(input "hi;world")
        ct_assert_not_string(input)
    ct_end_section()

    ct_add_section("An implicit list")
        set(input "hi" "world")
        ct_assert_not_string(input)
    ct_end_section()
ct_end_test()
