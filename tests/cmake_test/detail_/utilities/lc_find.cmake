include(cmake_test/cmake_test)

ct_add_test(NAME lc_find)
function(${lc_find})
    include(cmake_test/detail_/utilities/lc_find)

    ct_add_section(NAME test_string_not_present)
    function(${test_string_not_present})
        _ct_lc_find(result "not there" "hello world")
        ct_assert_equal(result "FALSE")
    endfunction()

    ct_add_section(NAME test_string_present_same_case)
    function(${test_string_present_same_case})
        _ct_lc_find(result "lo wo" "hello world")
        ct_assert_equal(result "TRUE")
    endfunction()

    ct_add_section(NAME test_string_present_different_case)
    function(${test_string_present_different_case})
        _ct_lc_find(result "Lo WO" "HeLlO woRlD")
        ct_assert_equal(result "TRUE")
    endfunction()
endfunction()
