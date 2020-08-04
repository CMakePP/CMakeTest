include(cmake_test/cmake_test)

ct_add_test(NAME "assert_equal")
function(${assert_equal})
    include(cmake_test/asserts/equal)

    ct_add_section(NAME "test_string")
    macro(${test_string}) #Macro so ${temp} is available to all subsections
        set(temp "hello world")

        ct_add_section(NAME strings_are_equal)
        function(${strings_are_equal})
            ct_assert_equal(temp "hello world")
        endfunction()

        ct_add_section(NAME strings_not_equal EXPECTFAIL)
        function(${strings_not_equal})
            ct_assert_equal(temp "Good bye")
        endfunction()
    endmacro()

    ct_add_section(NAME test_list)
    macro(${test_list}) #Macro so ${temp} is available to all subsections
        set(temp "hello;world")

        ct_add_section(NAME lists_are_equal)
        function(${lists_are_equal})
            ct_assert_equal(temp "hello;world")
        endfunction()

        ct_add_section(NAME lists_not_equal EXPECTFAIL)
        function(${lists_not_equal})
            ct_assert_equal(temp "hello")
        endfunction()
    endmacro()
endfunction()


ct_add_test(NAME assert_not_equal)
macro(${assert_not_equal}) #Macro so ${temp} is available to all subsections
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
endmacro()
