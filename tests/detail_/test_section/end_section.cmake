include(cmake_test/cmake_test)

ct_add_test("TestState::end_section")
    include(cmake_test/detail_/test_section/end_section)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg1 is not a handle")
        _ct_test_section_end_section(handle2 parent)
        ct_assert_fails_as("_tses_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg2 is empty")
        _ct_test_section_end_section(${handle} "")
        ct_assert_fails_as("_tses_parent is empty")
    ct_end_section()

    ct_add_section("fails if we are not in a section")
        _ct_test_section_end_section(${handle} parent)
        ct_assert_fails_as("Provided TestSection is not a section")
    ct_end_section()

    ct_add_section("actually works")
        test_section(ADD_SECTION ${handle} child "subsection")
        _ct_test_section_end_section(${child} result)
        ct_assert_equal(result "${handle}")
    ct_end_section()

ct_end_test()
