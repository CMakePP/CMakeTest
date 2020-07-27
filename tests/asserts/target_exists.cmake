include(cmake_test/cmake_test)

ct_add_test("assert_target_exists")
    include(cmake_test/asserts/target_exists)

    file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/a.c" "")
    add_library(my_lib "${CMAKE_CURRENT_BINARY_DIR}/a.c")

    ct_add_section("Target exists")
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
    ct_end_section()

    ct_add_section("Target does not exist")
        ct_assert_target_exists(non_existant_target)
        ct_assert_fails_as("Target non_existant_target does not exist.")
    ct_end_section()
ct_end_test()

ct_add_test("assert_target_does_not_exist")
    include(cmake_test/asserts/target_exists)

    ct_add_section("Target exists")
        add_custom_target(my_target ALL)
        ct_assert_target_does_not_exist(my_target)
        ct_assert_fails_as("Target my_target does exist.")
    ct_end_section()

    ct_add_section("Target does not exist")
        ct_assert_target_does_not_exist(non_existant_target)
    ct_end_section()
ct_end_test()
