include(cmake_test/cmake_test)

ct_add_test("TestSection::should_fail")
    include(cmake_test/detail_/test_section/should_fail)
    include(cmake_test/detail_/test_section/test_section)

    _ct_test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_should_fail(handle2)
        ct_assert_fails_as("_tssf_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("works")
        _ct_test_section_should_fail(${handle})
        _ct_test_section(SHOULD_PASS ${handle} result)
        ct_assert_equal(result "FALSE")
    ct_end_section()
ct_end_test()
