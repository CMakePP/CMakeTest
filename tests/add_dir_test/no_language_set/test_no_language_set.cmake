ct_add_test(NAME test_no_language_set)
function(${test_no_language_set})
    cpp_enabled_languages(the_enabled_languages)

    set(correct_value "C")
    ct_assert_equal(the_enabled_languages "${correct_value}")
endfunction()