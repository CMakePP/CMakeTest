include(cmake_test/cmake_test)

ct_add_test("TestSection")
    include(cmake_test/detail_/test_section/test_section)

    ct_add_section("fails if not a function")
        _ct_test_section(NOT_A_FXN ${handle})
        ct_assert_fails_as("Class TestSection has no member: NOT_A_FXN")
    ct_end_section()

    ct_add_section("CTOR")
        _ct_test_section(CTOR handle "title")
        _ct_is_handle(handle)

        ct_add_section("TITLE")
            _ct_test_section(TITLE ${handle} result)
            ct_assert_equal(result "title")
        ct_end_section()

        ct_add_section("ADD_CONTENT")
            set(string "hi")
            _ct_test_section(ADD_CONTENT ${handle} string)

            ct_add_section("GET_CONTENT")
                _ct_test_section(GET_CONTENT ${handle} result)
                ct_assert_equal(result "hi")
            ct_end_section()
        ct_end_section()

        ct_add_section("ADD_SECTION")
            _ct_test_section(ADD_SECTION ${handle} child "hi")
            _ct_is_handle(child)

            ct_add_section("END_SECTION")
                _ct_test_section(END_SECTION ${child} result)
                ct_assert_equal(result "${handle}")
            ct_end_section()
        ct_end_section()

        ct_add_section("SHOULD_PASS")
            _ct_test_section(SHOULD_PASS ${handle} result)
            ct_assert_equal(result "TRUE")
        ct_end_section()

        ct_add_section("SHOULD_FAIL")
            _ct_test_section(SHOULD_FAIL ${handle})
            _ct_test_section(SHOULD_PASS ${handle} result)
            ct_assert_equal(result "FALSE")
        ct_end_section()

        ct_add_section("TEST_PREFIX")
            _ct_test_section(TEST_PREFIX ${handle} result)
            ct_assert_equal(result "title")
        ct_end_section()

        ct_add_section("MUST_PRINT")
            _ct_test_section(MUST_PRINT ${handle} "hi")
            _ct_get_prop(${handle} result "print_assert")
            ct_assert_equal(result "hi")
        ct_end_section()
    ct_end_section()
ct_end_test()
