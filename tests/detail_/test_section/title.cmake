include(cmake_test/cmake_test)

ct_add_test("TestSection::title")
    include(cmake_test/detail_/test_section/title)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_get_title(handle2 result)
        ct_assert_fails_as("_tsgt_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_get_title(${handle} "")
        ct_assert_fails_as("_tsgt_title is empty")
    ct_end_section()

    ct_add_section("works")
        _ct_test_section_get_title(${handle} result)
        ct_assert_equal(result "title")
    ct_end_section()
ct_end_test()
