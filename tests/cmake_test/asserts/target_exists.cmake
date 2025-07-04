include(cmake_test/cmake_test)

ct_add_test(NAME assert_target_exists)
function(${assert_target_exists})
    include(cmake_test/asserts/target_exists)

    ct_add_section(NAME test_target_exists)
    function(${test_target_exists})
        set(target_name "target_${test_target_exists}")

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/a.c" "")
        add_library("${target_name}" "${CMAKE_CURRENT_BINARY_DIR}/a.c")
        ct_assert_target_exists("${target_name}")
    endfunction()

    ct_add_section(NAME test_target_does_not_exist EXPECTFAIL)
    function(${test_target_does_not_exist})
        set(target_name "target_${test_target_does_not_exists}")
        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/a.c" "")
        add_library("${target_name}" "${CMAKE_CURRENT_BINARY_DIR}/a.c")
        ct_assert_target_exists(non_existant_target)
    endfunction()

endfunction()

ct_add_test(NAME assert_target_does_not_exist)
function(${assert_target_does_not_exist})
    include(cmake_test/asserts/target_exists)

    ct_add_section(NAME test_target_exists EXPECTFAIL)
    function(${test_target_exists})
        set(target_name "target_${test_target_exist}")
        add_custom_target("${target_name}" ALL)
        ct_assert_target_does_not_exist("${target_name}")
    endfunction()

    ct_add_section(NAME test_target_does_not_exist)
    function(${test_target_does_not_exist})
        ct_assert_target_does_not_exist(non_existant_target)
    endfunction()
endfunction()
