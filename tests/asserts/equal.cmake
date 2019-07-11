include(cmake_test/cmake_test)

ct_add_test("assert_equal")
    include(cmake_test/asserts/equal)

    ct_add_section("string")
        set(temp "hello world")

        ct_add_section("are equal")
            ct_assert_equal(temp "hello world")
        ct_end_section()

        ct_add_section("not equal")
            ct_assert_equal(temp "Good bye")
            ct_assert_fails_as("Assertion: \"temp\" == \"Good bye\" failed.")
        ct_end_section()
    ct_end_section()

    ct_add_section("list")
        set(temp "hello;world")

        ct_add_section("are equal")
            ct_assert_equal(temp "hello;world")
        ct_end_section()

        ct_add_section("not equal")
            ct_assert_equal(temp "hello")
            ct_assert_fails_as("Assertion: \"temp\" == \"hello\" failed.")
        ct_end_section()
    ct_end_section()
ct_end_test()


ct_add_test("assert_not_equal")
    include(cmake_test/asserts/equal)
    set(temp "hello world")

    ct_add_section("are equal")
        ct_assert_not_equal(temp "hello world")
        ct_assert_fails_as("Assertion: \"temp\" != \"hello world\" failed.")
    ct_end_section()

    ct_add_section("not equal")
        ct_assert_not_equal(temp "Good bye")
    ct_end_section()
ct_end_test()
