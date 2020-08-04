include(cmake_test/cmake_test)

ct_add_test(NAME assert_file_exists)
function(${assert_file_exists})
    include(cmake_test/asserts/file_exists)

    ct_add_section(NAME test_file_exists)
    function(${test_file_exists})
        ct_assert_file_exists("${CMAKE_CURRENT_LIST_FILE}")
    endfunction()

    ct_add_section(NAME test_file_does_not_exist EXPECTFAIL)
    function(${test_file_does_not_exist})
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt")
    endfunction()

    ct_add_section(NAME test_is_directory EXPECTFAIL)
    function(${test_is_directory})
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}")
    endfunction()
endfunction()

ct_add_test(NAME assert_file_does_not_exist)
function(${assert_file_does_not_exist})
    include(cmake_test/asserts/file_exists)

    ct_add_section(NAME test_file_exists EXPECTFAIL)
    function(${test_file_exists})
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_LIST_FILE}")
    endfunction()

    ct_add_section(NAME test_file_does_not_exist)
    function(${test_file_does_not_exist})
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt")
    endfunction()

    ct_add_section(NAME test_is_directory)
    function(${test_is_directory})
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_BINARY_DIR}")
    endfunction()
endfunction()
