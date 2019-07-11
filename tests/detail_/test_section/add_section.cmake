include(cmake_test/cmake_test)

ct_add_test("TestSection::add_section")
    include(cmake_test/detail_/test_section/add_section)
    include(cmake_test/detail_/test_section/test_section)

    test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_add_section(handle2 child "subsection")
        ct_assert_fails_as("_tsas_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_add_section(${handle} "" "subsection")
        ct_assert_fails_as("_tsas_child is empty.")
    ct_end_section()

    ct_add_section("fails if arg 3 is empty")
        _ct_test_section_add_section(${handle} child "")
        ct_assert_fails_as("_tsas_name is empty")
    ct_end_section()

    ct_add_section("valid call")
        _ct_test_section_add_section(${handle} child "subsection")

        ct_add_section("sets child title correctly")
            test_section(TITLE ${child} result)
            ct_assert_equal(result "subsection")
        ct_end_section()

        ct_add_section("sets parent correctly")
            _ct_get_prop(${child} result "parent_section")
            ct_assert_equal(result "${handle}")
        ct_end_section()

        ct_add_section("prints title first call")
            ct_assert_prints("title:")
        ct_end_section()

        ct_add_section("Add subsubsection")
            _ct_test_section_add_section(${child} grandchild "subsubsection")

            ct_add_section("sets granchild title correctly")
                test_section(TITLE ${grandchild} result)
                ct_assert_equal(result "subsubsection")
            ct_end_section()

            ct_add_section("sets parent correctly")
                _ct_get_prop(${grandchild} result "parent_section")
                ct_assert_equal(result "${child}")
            ct_end_section()

            ct_add_section("prints indented title")
                ct_assert_prints("    subsection:")
            ct_end_section()
        ct_end_section()
    ct_end_section()
ct_end_test()
