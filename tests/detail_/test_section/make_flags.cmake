include_guard()
include(cmake_test/cmake_test)

ct_add_test("TestSection::make_flags")
    include(cmake_test/cmake_test)
    include(cmake_test/detail_/test_section/make_flags)
    include(cmake_test/detail_/test_section/test_section)
    set(
        corr_pfx "-Hdir/src;-Bdir/build_dir;-DCMAKE_INSTALL_PREFIX=dir/install"
                 "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"
    )
    _ct_test_section(CTOR handle "title")

    ct_add_section("fails if arg 1 is not a handle")
        _ct_test_section_make_flags(handle2 result dir)
        ct_assert_fails_as("_tsmf_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg 2 is empty")
        _ct_test_section_make_flags(${handle} "" dir)
        ct_assert_fails_as("_tsmf_result is empty")
    ct_end_section()

    ct_add_section("fails if arg 3 is empty")
        _ct_test_section_make_flags(${handle} result "")
        ct_assert_fails_as("_tsmf_dir is empty")
    ct_end_section()

    ct_add_section("no subsection")
        _ct_test_section_make_flags(${handle} result dir)
        ct_assert_equal(result "${corr_pfx}")
    ct_end_section()

    ct_add_section("subsection")
        _ct_test_section(ADD_SECTION ${handle} subsec "subsection")
        _ct_test_section_make_flags(${subsec} result dir)
        ct_assert_equal(result "${corr_pfx}")
    ct_end_section()
ct_end_test()
