include(cmake_test/cmake_test)

ct_add_test("TestSection::should_pass")
    include(cmake_test/detail_/test_section/should_pass)
    include(cmake_test/detail_/test_section/test_section)

    _ct_test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not handle")
        _ct_test_section_should_pass(handle2 result)
        ct_assert_fails_as("_tssp_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_should_pass(${handle} "")
        ct_assert_fails_as("_tssp_result is empty")
    ct_end_section()

    ct_add_section("no subsection")
        _ct_test_section_should_pass(${handle} result)
        ct_assert_equal(result "TRUE")
    ct_end_section()

    ct_add_section("subsection")
        ct_add_section("parent pass")
            _ct_test_section(CTOR subsec "subsec" ${handle})

            ct_add_section("subsection pass")
                _ct_test_section_should_pass(${subsec} result)
                ct_assert_equal(result "TRUE")
            ct_end_section()

            ct_add_section("subsection fail")
                _ct_test_section_should_fail(${subsec})
                _ct_test_section_should_pass(${subsec} result)
                ct_assert_equal(result "FALSE")
            ct_end_section()
        ct_end_section()

        ct_add_section("parent fail")
            _ct_test_section_should_fail(${handle})
            _ct_test_section(CTOR subsec "subsec" ${handle})

            ct_add_section("subsection pass")
                _ct_test_section_should_pass(${subsec} result)
                ct_assert_equal(result "FALSE")
            ct_end_section()

            ct_add_section("subsection fail")
                _ct_test_section_should_fail(${subsec})
                _ct_test_section_should_pass(${subsec} result)
                ct_assert_equal(result "FALSE")
            ct_end_section()
        ct_end_section()

    ct_end_section()
ct_end_test()
