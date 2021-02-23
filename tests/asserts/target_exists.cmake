include(cmake_test/cmake_test)
cmake_policy(SET CMP0002 OLD) #Allow duplicate targets by overriding, needed for multiple tests that work with the same target


ct_add_test(NAME assert_target_exists)
function(${assert_target_exists})
    include(cmake_test/asserts/target_exists)
    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/a.c" "")
    add_library(my_lib "${CMAKE_CURRENT_BINARY_DIR}/a.c")

    ct_add_section(NAME test_target_exists)
    function(${test_target_exists})
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
    endfunction()

    ct_add_section(NAME test_target_does_not_exist EXPECTFAIL)
    function(${test_target_does_not_exist})
        ct_assert_target_exists(non_existant_target)
    endfunction()
endfunction()

ct_add_test(NAME assert_target_does_not_exist)
function(${assert_target_does_not_exist})
    include(cmake_test/asserts/target_exists)

    ct_add_section(NAME test_target_exists EXPECTFAIL)
    function(${test_target_exists})
        add_custom_target(my_target ALL)
        ct_assert_target_does_not_exist(my_target)
    endfunction()

    ct_add_section(NAME test_target_does_not_exist)
    function(${test_target_does_not_exist})
        ct_assert_target_does_not_exist(non_existant_target)
    endfunction()
endfunction()
