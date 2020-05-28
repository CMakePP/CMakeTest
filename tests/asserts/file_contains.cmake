include(cmake_test/cmake_test)

ct_add_test("assert_file_contains")
    include(cmake_test/asserts/file_contains)

    ct_add_section("File exists")
        # Create file and match / no match strings
        set(file_name "${CMAKE_CURRENT_BINARY_DIR}/test_file.txt")
        set(match_string "match string")
        set(no_match_string "no match string")
        set(file_contents "here are the file contents ${match_string} more stuff")
        file(WRITE "${file_name}" "${file_contents}")

        ct_add_section("File contains text")
            ct_assert_file_contains("${file_name}" "${match_string}")
        ct_end_section()

        ct_add_section("File does not contain text")
            ct_assert_file_contains("${file_name}" "${no_match_string}")
            ct_assert_fails_as("does not contain text \"no match string\"")
        ct_end_section()
    ct_end_section()

    ct_add_section("File does not exist")
        ct_assert_file_contains("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt" "text")
        ct_assert_fails_as("File does not exist at")
    ct_end_section()

    ct_add_section("Is a directory")
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}" "text")
        ct_assert_fails_as("is a directory not a file.")
    ct_end_section()
ct_end_test()

ct_add_test("assert_file_does_not_contain")
    include(cmake_test/asserts/file_contains)

    ct_add_section("File exists")
        # Create file and match / no match strings
        set(file_name "${CMAKE_CURRENT_BINARY_DIR}/test_file.txt")
        set(match_string "match string")
        set(no_match_string "no match string")
        set(file_contents "here are the file contents ${match_string} more stuff")
        file(WRITE "${file_name}" "${file_contents}")

        ct_add_section("File contains text")
            ct_assert_file_does_not_contain("${file_name}" "${match_string}")
            ct_assert_fails_as("contains text \"match string\"")
        ct_end_section()

        ct_add_section("File does not contain text")
            ct_assert_file_does_not_contain("${file_name}" "${no_match_string}")
        ct_end_section()
    ct_end_section()

    ct_add_section("File does not exist")
        ct_assert_file_does_not_contain(
            "${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt" "text"
        )
        ct_assert_fails_as("File does not exist at")
    ct_end_section()

    ct_add_section("Is a directory")
        ct_assert_file_does_not_contain("${CMAKE_CURRENT_BINARY_DIR}" "text")
        ct_assert_fails_as("is a directory not a file.")
    ct_end_section()
ct_end_test()
