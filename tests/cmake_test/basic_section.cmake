#[[[
# This file just shows how to write a basic test section.
#]]
ct_add_test(NAME basic_test)
function(${basic_test})

    ct_add_section(NAME basic_section)
    function(${basic_section})

        message("Basic Section")
        ct_assert_prints("Basic Section")

    endfunction()

endfunction()
