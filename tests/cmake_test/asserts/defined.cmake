
ct_add_test(NAME assert_defined)
function(${assert_defined})
    include(cmake_test/asserts/defined)

    ct_add_section(NAME test_sig EXPECTFAIL)
    function(${test_sig})
        ct_assert_defined(TRUE)
    endfunction()

    ct_add_section(NAME test_is_defined)
    function(${test_is_defined})
        set(is_defined "")
        ct_assert_defined(is_defined)
    endfunction()

    ct_add_section(NAME test_is_not_defined EXPECTFAIL)
    function(${test_is_not_defined})
        ct_assert_defined(is_defined)
    endfunction()
endfunction()

ct_add_test(NAME assert_not_defined)
function(${assert_not_defined})
    include(cmake_test/asserts/defined)

    ct_add_section(NAME test_sig EXPECTFAIL)
    function(${test_sig})
        ct_assert_not_defined(TRUE)
    endfunction()

    ct_add_section(NAME test_is_defined EXPECTFAIL)
    function(${test_is_defined})
        set(is_defined "")
        ct_assert_not_defined(is_defined)
    endfunction()

    ct_add_section(NAME test_is_not_defined)
    function(${test_is_not_defined})
        ct_assert_not_defined(is_defined)
    endfunction()
endfunction()
