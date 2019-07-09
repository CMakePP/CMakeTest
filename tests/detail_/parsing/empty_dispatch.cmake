include(cmake_test/cmake_test)

ct_add_test("empty_dispatch")
    include(cmake_test/detail_/parsing/empty_dispatch)

    ct_add_section("Should trigger")
        # If empty_dispatch doesn't return, empty_tester will crash
        function(empty_tester et_arg1)
            _ct_empty_dispatch("${_et_arg1}")
            message(FATAL_ERROR "Empty dispatch didn't work")
        endfunction()

        ct_add_section("empty string")
            empty_tester("")
        ct_end_section()

        ct_add_section("blank line")
            empty_tester("              ")
        ct_end_section()
    ct_end_section()

    ct_add_section("Shouldn't trigger")
        # If empty_dispatch returns, nonempty_tester will not set correct
        function(nonempty_tester nt_arg1)
            message("Huh? ${nt_arg1}")
            _ct_empty_dispatch("${nt_arg1}")
            set(correct "TRUE" PARENT_SCOPE)
        endfunction()

        nonempty_tester("Hi")
        ct_assert_equal(correct "TRUE")
    ct_end_section()

ct_end_test()
