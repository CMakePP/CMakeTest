include(cmake_test/cmake_test)

ct_add_test("TestSection::should_pass")
    include(cmake_test/detail_/test_section/should_pass)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not handle")
        _ct_test_section_should_pass(handle2 result)
        ct_assert_fails_as("_tssp_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_should_pass(${handle} "")
        ct_assert_fails_as("_tssp_result is empty")
    ct_end_section()

    ct_add_section("works")
        _ct_test_section_should_pass(${handle} result)
        ct_assert_equal(result "TRUE")
    ct_end_section()
ct_end_test()
