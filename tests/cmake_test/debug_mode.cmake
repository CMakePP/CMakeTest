

ct_add_test(NAME test_debug_mode)
function(${test_debug_mode})
    cpp_get_global(ct_debug_mode "CT_DEBUG_MODE")
    ct_assert_true(ct_debug_mode)
    ct_assert_true(CMAKEPP_LANG_DEBUG_MODE)
endfunction()

ct_add_test(NAME test_debug_mode_set_false)
function(${test_debug_mode_set_false})
    set(CMAKEPP_LANG_DEBUG_MODE FALSE)

    ct_add_section(NAME test_cmakepplang_debug_mode)
    function(${test_cmakepplang_debug_mode})

        cpp_get_global(ct_debug_mode "CT_DEBUG_MODE")
        ct_assert_true(ct_debug_mode)
        ct_assert_false(CMAKEPP_LANG_DEBUG_MODE)
    endfunction()
endfunction()