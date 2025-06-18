ct_add_test(NAME test_set_languages)
function(${test_set_languages})
    cpp_enabled_languages(the_enabled_languages)

    set(correct_value "C;CXX")
    ct_assert_equal(the_enabled_languages "${correct_value}")
endfunction()