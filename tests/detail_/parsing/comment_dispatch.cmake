include(cmake_test/cmake_test)

ct_add_test("comment_dispatch")
    include(cmake_test/detail_/parsing/comment_dispatch)

    ct_add_section("is comment")

        # This function crashes test if comment is not detected
        function(comment_test ct_line)
            _ct_comment_dispatch("${ct_line}")
            message(FATAL_ERROR "Failed to detect comment")
        endfunction()

        ct_add_section("First character")
            comment_test("#A comment")
        ct_end_section()

        ct_add_section("Whitespace before comment")
            comment_test("    # A comment")
        ct_end_section()

    ct_end_section()

    ct_add_section("is not comment")

        # This function won't set correct if line is registered as comment
        function(not_comment_test nct_line)
            _ct_comment_dispatch("${nct_line}")
            set(correct "TRUE" PARENT_SCOPE)
        endfunction()

        ct_add_section("legit code")
            not_comment_test("set(variable value)")
            ct_assert_equal(correct "TRUE")
        ct_end_section()

        ct_add_section("doesn't detect trailing comments")
            not_comment_test("set(variable value) # a trailing comment")
            ct_assert_equal(correct "TRUE")
        ct_end_section()

    ct_end_section()

ct_end_test()
