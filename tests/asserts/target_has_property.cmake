include(cmake_test/cmake_test)
cmake_policy(SET CMP0002 OLD) #Allow duplicate targets by overriding, needed for multiple tests that work with the same target

ct_add_test(NAME assert_target_has_property)
function(${assert_target_has_property})
    include(cmake_test/asserts/target_has_property)

    ct_add_section(NAME test_target_exists)
    function(${test_target_exists})
        # Create target and add property
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
        set_target_properties(
            my_target
            PROPERTIES property_1 value_1
        )

        ct_add_section(NAME test_target_has_property)
        function(${test_target_has_property})
            ct_assert_target_has_property(my_target property_1)
        endfunction()

        ct_add_section(NAME test_target_does_not_have_property EXPECTFAIL)
        function(${test_target_does_not_have_property})
            ct_assert_target_has_property(my_target non_existant_property)
        endfunction()
    endfunction()

    ct_add_section(NAME test_target_does_not_exist EXPECTFAIL)
    function(${test_target_does_not_exist})
        ct_assert_target_exists(non_existant_target)
    endfunction()
endfunction()

ct_add_test(NAME assert_target_does_not_have_property)
function(${assert_target_does_not_have_property})
    include(cmake_test/asserts/target_has_property)

    ct_add_section(NAME test_target_exists)
    function(${test_target_exists})
        # Create target and add property
        add_custom_target(my_target ALL)
        ct_assert_target_exists(my_target)
        set_target_properties(
            my_target
            PROPERTIES property_1 value_1
        )

        ct_add_section(NAME test_target_has_property EXPECTFAIL)
        function(${test_target_has_property})
            ct_assert_target_does_not_have_property(my_target property_1)
        endfunction()

        ct_add_section(NAME test_target_does_not_have_property)
        function(${test_target_does_not_have_property})
            ct_assert_target_does_not_have_property(my_target non_existant_property)
        endfunction()
    endfunction()

    ct_add_section(NAME test_target_does_not_exist EXPECTFAIL)
    function(${test_target_does_not_exist})
        ct_assert_target_exists(non_existant_target)
    endfunction()
endfunction()
