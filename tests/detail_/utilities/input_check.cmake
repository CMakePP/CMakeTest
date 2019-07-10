include(cmake_test/cmake_test)

ct_add_test("nonempty")
    include(cmake_test/detail_/utilities/input_check)

    ct_add_section("Does nothing if input is non-empty")
        set(input "x")
        _ct_nonempty(input)
    ct_end_section()

    ct_add_section("Crashes if not identifier")
        _ct_nonempty("hello")
        ct_assert_fails_as("hello is empty.")
    ct_end_section()

    ct_add_section("Crashes if empty")
        set(hello "")
        _ct_nonempty(hello)
        ct_assert_fails_as("hello is empty.")
    ct_end_section()
ct_end_test()

ct_add_test("nonempty_string")
    include(cmake_test/detail_/utilities/input_check)

    ct_add_section("Does nothing if input is non-empty string")
        set(input "x")
        _ct_nonempty_string(input)
    ct_end_section()

    ct_add_section("Crashes if not identifier")
        _ct_nonempty_string("hello")
        ct_assert_fails_as("hello is empty.")
    ct_end_section()

    ct_add_section("Crashes if empty")
        set(hello "")
        _ct_nonempty_string(hello)
        ct_assert_fails_as("hello is empty.")
    ct_end_section()

    ct_add_section("Crashes if contents is a list")
        set(hello "one" "two")
        _ct_nonempty_string(hello)
        ct_assert_fails_as("hello is list: one")
    ct_end_section()
ct_end_test()

ct_add_test("is_handle")
    include(cmake_test/detail_/utilities/input_check)

    ct_add_section("Does nothing if input is a handle")
        set(input "x_test_section")
        _ct_is_handle(input)
    ct_end_section()

    ct_add_section("Crashes if not identifier")
        _ct_is_handle("hello")
        ct_assert_fails_as("hello is empty.")
    ct_end_section()

    ct_add_section("Crashes if empty")
        set(hello "")
        _ct_is_handle(hello)
        ct_assert_fails_as("hello is empty.")
    ct_end_section()

    ct_add_section("Crashes if contents is a list")
        set(hello "one" "two")
        _ct_is_handle(hello)
        ct_assert_fails_as("hello is list: one")
    ct_end_section()

    ct_add_section("Crashes if string is not a handle")
        set(hello "hello")
        _ct_is_handle(hello)
        ct_assert_fails_as("hello is not a handle to a TestSection.")
    ct_end_section()
ct_end_test()
