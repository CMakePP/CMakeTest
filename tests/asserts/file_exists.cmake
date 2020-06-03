include(cmake_test/cmake_test)

ct_add_test("assert_file_exists")
    include(cmake_test/asserts/file_exists)

    ct_add_section("File exists")
        ct_assert_file_exists("${CMAKE_CURRENT_LIST_FILE}")
    ct_end_section()

    ct_add_section("File does not exist")
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt")
        ct_assert_fails_as("File does not exist at")
    ct_end_section()

    ct_add_section("Is a directory")
        ct_assert_file_exists("${CMAKE_CURRENT_BINARY_DIR}")
        ct_assert_fails_as("is a directory not a file.")
    ct_end_section()
ct_end_test()

ct_add_test("assert_file_does_not_exist")
    include(cmake_test/asserts/file_exists)

    ct_add_section("File exists")
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_LIST_FILE}")
        ct_assert_fails_as("File does exist at")
    ct_end_section()

    ct_add_section("File does not exist")
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_BINARY_DIR}/not_a_file.txt")
    ct_end_section()

    ct_add_section("Is a directory")
        ct_assert_file_does_not_exist("${CMAKE_CURRENT_BINARY_DIR}")
    ct_end_section()
ct_end_test()
