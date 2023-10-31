include(cmake_test/cmake_test)

#[[[
# This test just ensures that throwing a FATAL_ERROR
# in an EXPECTFAIL test will allow the test to succeed.
#]]
ct_add_test(NAME "make_sure_function_fails" EXPECTFAIL)
function("${CMAKETEST_TEST}")

    function(failing_fxn)
        message(FATAL_ERROR "I have erred.")
    endfunction()

    failing_fxn()

endfunction()