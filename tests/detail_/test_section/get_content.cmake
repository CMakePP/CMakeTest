include(cmake_test/cmake_test)

ct_add_test("TestSection::get_content")
    include(cmake_test/detail_/test_section/get_content)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_get_content(handle2 result)
        ct_assert_fails_as("_tsgc_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_get_content(${handle} "")
        ct_assert_fails_as("_tsgc_content is empty")
    ct_end_section()

    ct_add_section("no content to get")
        _ct_test_section_get_content(${handle} result)
        ct_assert_equal(result "")
    ct_end_section()

    ct_add_section("outer test has content")
        set(string "hello")
        test_section(ADD_CONTENT ${handle} string)
        _ct_test_section_get_content(${handle} result)
        ct_assert_equal(result "hello")

        ct_add_section("inner test has content")
            test_section(ADD_SECTION ${handle} child "child")
            test_section(ADD_CONTENT ${child} string)
            _ct_test_section_get_content(${child} result)
            ct_assert_equal(result "hello\nhello")
        ct_end_section()
    ct_end_section()
ct_end_test()
