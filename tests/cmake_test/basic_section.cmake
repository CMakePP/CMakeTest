#[[[
# This file just shows how to write a basic test section.
#]]
ct_add_test(NAME basic_test)
function(${CMAKETEST_TEST})

    ct_add_section(NAME basic_section)
    function(${CMAKETEST_SECTION})

        message("Basic Section")
        ct_assert_prints("Basic Section")

    endfunction()

endfunction()
