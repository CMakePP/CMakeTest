include(cmake_test/cmake_test)

ct_add_test(NAME assert_target_has_property)
function(${assert_target_has_property})
    include(cmake_test/asserts/target_has_property)

    ct_add_section(NAME test_target_exists)
    function(${test_target_exists})
        set(target_name "target_${assert_target_has_property}")
        # Create target and add property
        add_custom_target("${target_name}" ALL)
        ct_assert_target_exists("${target_name}")
        set_target_properties("${target_name}" PROPERTIES property_1 value_1)

        ct_assert_target_has_property("${target_name}" property_1)
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
        set(target_name "target_${test_target_exists}")

        # Create target and add property
        add_custom_target("${target_name}" ALL)
        ct_assert_target_exists("${target_name}")
        set_target_properties(
            "${target_name}"
            PROPERTIES property_1 value_1
        )

        ct_assert_target_does_not_have_property(
            "${target_name}" non_existant_property
        )
    endfunction()

    ct_add_section(NAME test_target_does_not_exist EXPECTFAIL)
    function(${test_target_does_not_exist})
        ct_assert_target_exists(non_existant_target)
    endfunction()
endfunction()
