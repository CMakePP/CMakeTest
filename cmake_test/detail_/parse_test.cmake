include_guard()
include(cmake_test/detail_/buffers)
include(cmake_test/detail_/debug)

macro(_ct_start_test _st_name)
    _ct_parse_debug("Parsing test ${_st_name}")
    #Error checking
    if(_ct_in_test) #Can't nest tests
        message(FATAL_ERROR "Nested test case. Did you forget ct_end_test?")
    endif()

    #Let the world know we are in a test
    set(_ct_in_test TRUE PARENT_SCOPE)

    #Initialize this test's properties
    set(_ct_test_name "${_st_name}" PARENT_SCOPE)
    _ct_recurse_buffers()
endmacro()

macro(_ct_finish_test)
    _ct_parse_debug("Finished parsing test.")
    _ct_pop_buffers()
    _ct_assert_empty()
endmacro()
