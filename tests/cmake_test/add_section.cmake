# Tests whether add_section()
# correctly executes sections and
# subsections

ct_add_test(NAME test_add_section_top_level)
function(${test_add_section_top_level})

    ct_add_section(NAME section_0)
    function(${section_0})
        cpp_set_global(TEST_ADD_SECTION_S0 TRUE)
    endfunction()

    ct_add_section(NAME section_1)
    function(${section_1})
       cpp_set_global(TEST_ADD_SECTION_S1 TRUE)

       ct_add_section(NAME subsection_0)
       function(${subsection_0})
           cpp_set_global(TEST_ADD_SECTION_S_S0 TRUE)
       endfunction()

       ct_add_section(NAME bool)
       function(${bool})
           cpp_set_global(TEST_ADD_SECTION_S_S1 TRUE)
       endfunction()
    endfunction()

    ct_add_section(NAME wrong_sig EXPECTFAIL)
    function("${wrong_sig}")
        ct_add_section(NAME "invalid_print_length" PRINT_LENGTH FALSE)
        function("${invalid_print_length}")
           message("This cannot be")
        endfunction()
    endfunction()

    ct_add_section(NAME invalid_name EXPECTFAIL)
    function("${invalid_name}")
        # CMake won't allow a variable name with spaces, so making a test
        # with such a name is impossible with the current implementation.
        # Well, technically not impossible, if you set a different
        # variable to the text "incomprehensible with spaces"
        # you can then double deference it to get the function identifier out.
        # We probably don't want to deal with that though
        ct_add_section(NAME "incomprehensible with spaces")
        function("${incomprehensible with spaces}")
           message("This cannot be")
        endfunction()
    endfunction()

endfunction()

ct_add_test(NAME test_sections_were_run)
function(${test_sections_were_run})
   cpp_get_global(s0 TEST_ADD_SECTION_S0)
   cpp_get_global(s1 TEST_ADD_SECTION_S1)
   cpp_get_global(s_s0 TEST_ADD_SECTION_S_S0)
   cpp_get_global(s_s1 TEST_ADD_SECTION_S_S1)


   ct_assert_true(s0)
   ct_assert_true(s1)
   ct_assert_true(s_s0)
   ct_assert_true(s_s1)
endfunction()
