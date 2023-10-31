# Tests whether ct_add_test()
# correctly executes sections and
# subsections

cpp_set_global("TEST_ADD_TEST_COUNTER" 0)

ct_add_test(NAME test_add_test)
function(${test_add_test})
    cpp_get_global(counter "TEST_ADD_TEST_COUNTER")
    math(EXPR counter ${counter}+1)
    cpp_set_global("TEST_ADD_TEST_COUNTER" ${counter})
endfunction()

ct_add_test(NAME test_test_was_run_once)
function(${test_test_was_run_once})
    cpp_get_global(counter "TEST_ADD_TEST_COUNTER")
    ct_assert_equal(counter 1)
endfunction()


ct_add_test(NAME [[arbitrary test name with $pecial ch&rs]])
function(${CMAKETEST_TEST})
    cpp_get_global(counter "TEST_ADD_TEST_2_COUNTER")
    math(EXPR counter ${counter}+1)
    cpp_set_global("TEST_ADD_TEST_2_COUNTER" ${counter})
endfunction()

ct_add_test(NAME test_test_2_was_run_once)
function(${test_test_2_was_run_once})
    cpp_get_global(counter "TEST_ADD_TEST_2_COUNTER")
    ct_assert_equal(counter 1)
endfunction()