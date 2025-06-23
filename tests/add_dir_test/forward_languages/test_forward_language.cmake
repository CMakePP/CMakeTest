ct_add_test(NAME test_forward_languages)
function(${test_forward_languages})
    cpp_enabled_languages(the_enabled_languages)

    set(correct_value "CXX")
    ct_assert_equal(the_enabled_languages "${correct_value}")
endfunction()