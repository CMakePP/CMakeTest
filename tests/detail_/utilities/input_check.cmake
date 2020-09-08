include(cmake_test/cmake_test)

ct_add_test(NAME nonempty)
function(${nonempty})
    include(cmake_test/detail_/utilities/input_check)

    ct_add_section(NAME test_nonempty)
    function(${test_nonempty})
        set(input "x")
        _ct_nonempty(input)
    endfunction()

    ct_add_section(NAME test_var_not_defined EXPECTFAIL)
    function(${test_var_not_defined})
        _ct_nonempty("hello")
    endfunction()

    ct_add_section(NAME test_defined_but_empty EXPECTFAIL)
    function(${test_defined_but_empty})
        set(hello "")
        _ct_nonempty(hello)
    endfunction()
endfunction()

ct_add_test(NAME nonempty_string)
function(${nonempty_string})
    include(cmake_test/detail_/utilities/input_check)

    ct_add_section(NAME test_nonempty_string)
    function(${nonempty_string})
        set(input "x")
        _ct_nonempty_string(input)
    endfunction()

    ct_add_section(NAME test_var_not_defined EXPECTFAIL)
    function(${test_var_not_defined})
        _ct_nonempty_string("hello")
    endfunction()

    ct_add_section(NAME test_defined_but_empty EXPECTFAIL)
    function(${test_defined_but_empty})
        set(hello "")
        _ct_nonempty_string(hello)
    endfunction()

    ct_add_section(NAME test_list EXPECTFAIL)
    function(${test_list})
        set(hello "one" "two")
        _ct_nonempty_string(hello)
    endfunction()
endfunction()

