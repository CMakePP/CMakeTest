include(cmake_test/cmake_test)

ct_add_test(NAME "assert_equal")
function(${assert_equal})
    include(cmake_test/asserts/equal)

    ct_add_section(NAME "test_string")
    function(${test_string})
        set(temp "hello world")

        ct_add_section(NAME strings_are_equal)
        function(${strings_are_equal})
            ct_assert_equal(temp "hello world")
        endfunction()

        ct_add_section(NAME strings_not_equal EXPECTFAIL)
        function(${strings_not_equal})
            ct_assert_equal(temp "Good bye")
        endfunction()
    endfunction()

    ct_add_section(NAME test_list)
    function(${test_list})
        set(temp "hello;world")

        ct_add_section(NAME lists_are_equal)
        function(${lists_are_equal})
            ct_assert_equal(temp "hello;world")
        endfunction()

        ct_add_section(NAME lists_not_equal EXPECTFAIL)
        function(${lists_not_equal})
            ct_assert_equal(temp "hello")
        endfunction()
    endfunction()
endfunction()


ct_add_test(NAME assert_not_equal)
function(${assert_not_equal})
    include(cmake_test/asserts/equal)
    set(temp "hello world")

    ct_add_section(NAME strings_are_equal EXPECTFAIL)
    function(${strings_are_equal})
        ct_assert_not_equal(temp "hello world")
    endfunction()

    ct_add_section(NAME strings_not_equal)
    function(${strings_not_equal})
        ct_assert_not_equal(temp "Good bye")
    endfunction()
endfunction()
