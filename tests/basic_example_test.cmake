include(cmake_test/cmake_test)


ct_add_test(NAME "_first_test")
function(${_first_test})
    set(hello_world "Hello World!!!")
    ct_assert_equal(hello_world "Hello World!!!")
endfunction()