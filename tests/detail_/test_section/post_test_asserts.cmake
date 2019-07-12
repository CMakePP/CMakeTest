include(cmake_test/cmake_test)

ct_add_test("TestSection::post_test_asserts")
    include(cmake_test/detail_/test_section/post_test_asserts)
    include(cmake_test/detail_/test_section/test_section)

    _ct_test_section(CTOR handle "title")

    ct_add_section("fails if arg1 is not a handle")
        _ct_test_section_post_test_asserts(handle2 0 "hi")
        ct_assert_fails_as("_tspta_handle is not a handle to a TestSection")
    ct_end_section()

    ct_add_section("fails if arg2 is empty")
        _ct_test_section_post_test_asserts(${handle} "" "hi")
        ct_assert_fails_as("_tspta_result is empty")
    ct_end_section()

    ct_add_section("fails if result fails, but should have passed")
        _ct_test_section_post_test_asserts(${handle} "1" "hi")
        ct_assert_fails_as("Output: hi")
    ct_end_section()

    ct_add_section("fails if passes, but should have failed")
        _ct_test_section(SHOULD_FAIL ${handle})
        _ct_test_section_post_test_asserts(${handle} "0" "hi")
        ct_assert_fails_as("Test passed and it should have failed")
    ct_end_section()

    ct_add_section("fails if text does not appear")
        _ct_test_section(MUST_PRINT ${handle} "bye")
        _ct_test_section_post_test_asserts(${handle} "0" "hi")
        ct_assert_fails_as("bye was not found in output")
    ct_end_section()

    ct_add_section("works")
        _ct_test_section(MUST_PRINT ${handle} "hi")
        _ct_test_section_post_test_asserts(${handle} "0" "hi")
    ct_end_section()
ct_end_test()
