include(cmake_test/cmake_test)

ct_add_test("assert_defined")
    include(cmake_test/asserts/defined)

    ct_add_section("is defined")
        set(is_defined "")
        ct_assert_defined(is_defined)
    ct_end_section()

    ct_add_section("is not defined")
        ct_assert_defined(is_defined)
        ct_assert_fails_as("is_defined is not defined.")
    ct_end_section()
ct_end_test()

ct_add_test("assert_not_defined")
    include(cmake_test/asserts/defined)

    ct_add_section("is defined")
        set(is_defined "")
        ct_assert_not_defined(is_defined)
        ct_assert_fails_as("is_defined is defined.")
    ct_end_section()

    ct_add_section("is not defined")
        ct_assert_not_defined(is_defined)
    ct_end_section()
ct_end_test()
