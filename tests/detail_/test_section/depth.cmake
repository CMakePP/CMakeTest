include(cmake_test/cmake_test)

ct_add_test("TestSection::depth")
    include(cmake_test/detail_/test_section/depth)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg1 is not a handle")
        _ct_test_section_depth(handle2 result)
        ct_assert_fails_as("_tsd_handle is not a handle to a TestSection.")
    ct_end_section()

    ct_add_section("fails if arg2 is empty")
        _ct_test_section_depth(${handle} "")
        ct_assert_fails_as("_tsd_depth is empty.")
    ct_end_section()

    ct_add_section("Outer test")
        _ct_test_section_depth(${handle} result)
        ct_assert_equal(result "0")

        ct_add_section("and a nested section")
            test_section(ADD_SECTION ${handle} child "subsection")
            _ct_test_section_depth(${child} result)
            ct_assert_equal(result "1")

            ct_add_section("and another nested section")
                test_section(ADD_SECTION ${child} grandchild "subsubsection")
                _ct_test_section_depth(${grandchild} result)
                ct_assert_equal(result "2")
            ct_end_section()
        ct_end_section()
    ct_end_section()
ct_end_test()
