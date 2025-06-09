include(cmake_test/cmake_test)

ct_add_test(NAME "assert_regex_equal")
function(${assert_regex_equal})
    include(cmake_test/asserts/regex_equal)

    set(is_true "TRUE")
    set(contains_a_number "Pi is 3.14")
    set(no_number "Pi is a Greek letter.")

    ct_add_section(NAME truthy_value_match)
    function(${truthy_value_match})
        ct_assert_regex_equal(is_true "TRUE")
        ct_assert_regex_equal(contains_a_number "[0-9]+\.[0-9]+")
    endfunction()

    ct_add_section(NAME truthy_value_no_match EXPECTFAIL)
    function(${truthy_value_no_match})
        ct_assert_regex_equal(is_true "FALSE")
        ct_assert_regex_equal(no_number "[0-9]+\.[0-9]+")
    endfunction()

endfunction()

ct_add_test(NAME "assert_regex_not_equal")
function(${assert_regex_not_equal})
    include(cmake_test/asserts/regex_equal)

    set(is_true "TRUE")
    set(contains_a_number "Pi is 3.14")
    set(no_number "Pi is a Greek letter.")

    ct_add_section(NAME truthy_value_no_match)
    function(${truthy_value_no_match})
        ct_assert_regex_not_equal(is_true "FALSE")
        ct_assert_regex_not_equal(no_number "[0-9]+\.[0-9]+")
    endfunction()

    ct_add_section(NAME truthy_value EXPECTFAIL)
    function(${truthy_value})
        ct_assert_regex_not_equal(is_true "TRUE")
        ct_assert_regex_not_equal(contains_a_number "[0-9]+\.[0-9]+")
    endfunction()

endfunction()