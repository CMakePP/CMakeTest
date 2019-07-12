include(cmake_test/cmake_test)

ct_add_test("TestState::test_prefix")
    include(cmake_test/detail_/test_section/test_prefix)
    include(cmake_test/detail_/test_section/test_section)

    _ct_test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_test_prefix(handle2 result)
        ct_assert_fails_as("_tstp_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_test_prefix(${handle} "")
        ct_assert_fails_as("_tstp_result is empty")
    ct_end_section()

    ct_add_section("no subsection")
        _ct_test_section_test_prefix(${handle} result)
        ct_assert_equal(result "title")
    ct_end_section()

    ct_add_section("subsection")
        ct_add_section("nice title")
            _ct_test_section(ADD_SECTION ${handle} subsec "subsection")
            _ct_test_section_test_prefix(${subsec} result)
            ct_assert_equal(result "title/subsection")
        ct_end_section()

        ct_add_section("mean title")
            _ct_test_section(ADD_SECTION ${handle} subsec "sub section")
            _ct_test_section_test_prefix(${subsec} result)
            ct_assert_equal(result "title/sub_section")
        ct_end_section()
    ct_end_section()
ct_end_test()
