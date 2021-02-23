include(cmake_test/cmake_test)

ct_add_test(NAME assert_file_contains)
function(${assert_file_contains})
    include(cmake_test/asserts/file_contains)

    ct_add_section(NAME test_file_exists)
    function(${test_file_exists})
        # Create file and match / no match strings
        set(file_name "${CMAKE_CURRENT_BINARY_DIR}/test_file.txt")
        set(match_string "match string")
        set(no_match_string "no match string")
        set(file_contents "here are the file contents ${match_string} more stuff")
        file(WRITE "${file_name}" "${file_contents}")

        ct_add_section(NAME test_file_contains_text)
        function(${test_file_contains_text})
            ct_assert_file_contains("${file_name}" "${match_string}")
        endfunction()

        ct_add_section(NAME test_file_does_not_contain_text EXPECTFAIL)
        function(${test_file_does_not_contain_text})
            ct_assert_file_contains("${file_name}" "${no_match_string}")
        endfunction()
    endfunction()

    ct_add_section(NAME test_file_does_not_exist EXPECTFAIL)
    function(${test_file_does_not_exist})
        ct_assert_file_contains("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt" "text")
    endfunction()

    ct_add_section(NAME test_is_directory EXPECTFAIL)
    function(${test_is_directory})
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}" "text")
    endfunction()
endfunction()

ct_add_test(NAME assert_file_does_not_contain)
function(${assert_file_does_not_contain})
    include(cmake_test/asserts/file_contains)

    ct_add_section(NAME test_file_exists)
    function(${test_file_exists})
        # Create file and match / no match strings
        set(file_name "${CMAKE_CURRENT_BINARY_DIR}/test_file.txt")
        set(match_string "match string")
        set(no_match_string "no match string")
        set(file_contents "here are the file contents ${match_string} more stuff")
        file(WRITE "${file_name}" "${file_contents}")

        ct_add_section(NAME test_file_contains_text EXPECTFAIL)
        function(${test_file_contains_text})
            ct_assert_file_does_not_contain("${file_name}" "${match_string}")
        endfunction()

        ct_add_section(NAME test_file_does_not_contain_text)
        function(${test_file_does_not_contain_text})
            ct_assert_file_does_not_contain("${file_name}" "${no_match_string}")
        endfunction()
    endfunction()

    ct_add_section(NAME test_file_does_not_exist EXPECTFAIL)
    function(${test_file_does_not_exist})
        ct_assert_file_does_not_contain(
            "${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt" "text"
        )
    endfunction()

    ct_add_section(NAME test_is_directory EXPECTFAIL)
    function(${test_is_directory})
        ct_assert_file_does_not_contain("${CMAKE_CURRENT_BINARY_DIR}" "text")
    endfunction()
endfunction()
