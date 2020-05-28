include(cmake_test/cmake_test)

ct_add_test("assert_target_has_property")
    include(cmake_test/asserts/target_has_property)

    ct_add_section("Target exists")
        # Create target and add property
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
        set_target_properties(
            my_target
            PROPERTIES property_1 value_1
        )

        ct_add_section("Target has property")
            ct_assert_target_has_property(my_target property_1)
        ct_end_section()

        ct_add_section("Target does not have property")
            ct_assert_target_has_property(my_target non_existant_property)
            ct_assert_fails_as("does not contain property non_existant_property")
        ct_end_section()
    ct_end_section()

    ct_add_section("Target does not exist")
        ct_assert_target_exists(non_existant_target)
        ct_assert_fails_as("Target non_existant_target does not exist.")
    ct_end_section()
ct_end_test()

ct_add_test("assert_target_does_not_have_property")
    include(cmake_test/asserts/target_has_property)

    ct_add_section("Target exists")
        # Create target and add property
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
        set_target_properties(
            my_target
            PROPERTIES property_1 value_1
        )

        ct_add_section("Target has property")
            ct_assert_target_does_not_have_property(my_target property_1)
            ct_assert_fails_as("contains property property_1")
        ct_end_section()

        ct_add_section("Target does not have property")
            ct_assert_target_does_not_have_property(my_target non_existant_property)
        ct_end_section()
    ct_end_section()

    ct_add_section("Target does not exist")
        ct_assert_target_exists(non_existant_target)
        ct_assert_fails_as("Target non_existant_target does not exist.")
    ct_end_section()
ct_end_test()
