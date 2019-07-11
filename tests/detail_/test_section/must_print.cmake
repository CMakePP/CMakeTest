include(cmake_test/cmake_test)

ct_add_test("TestSection::must_print")
    include(cmake_test/detail_/test_section/must_print)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_must_print(handle2 "hello")
        ct_assert_fails_as("_tsmp_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_must_print(${handle} "")
        ct_assert_fails_as("_tsmp_message is empty")
    ct_end_section()

    ct_add_section("works with string")
        _ct_test_section_must_print(${handle} "hello")
        _ct_get_prop(${handle} result "print_assert")
        ct_assert_equal(result "hello")

        ct_add_section("works with a second string")
            _ct_test_section_must_print(${handle} "world")
            _ct_get_prop(${handle} result "print_assert")
            ct_assert_equal(result "hello;world")
        ct_end_section()

        ct_add_section("and a list")
            _ct_test_section_must_print(${handle} "hello;world")
            _ct_get_prop(${handle} result "print_assert")
            ct_assert_equal(result "hello;hello\;world")
        ct_end_section()
    ct_end_section()

    ct_add_section("works with list")
        _ct_test_section_must_print(${handle} "hello;world")
        _ct_get_prop(${handle} result "print_assert")
        ct_assert_equal(result "hello\;world")

        ct_add_section("and a string")
            _ct_test_section_must_print(${handle} "hi")
            _ct_get_prop(${handle} result "print_assert")
            ct_assert_equal(result "hello\;world;hi")
        ct_end_section()

        ct_add_section("and another list")
            _ct_test_section_must_print(${handle} "good;bye")
            _ct_get_prop(${handle} result "print_assert")
            ct_assert_equal(result "hello\;world;good\;bye")
        ct_end_section()
    ct_end_section()
ct_end_test()
