include_guard()
include(cmake_test/detail_/test_state/add_content)
include(cmake_test/detail_/test_state/add_section)
include(cmake_test/detail_/test_state/ctor)
include(cmake_test/detail_/test_state/end_section)
include(cmake_test/detail_/test_state/get_content)
include(cmake_test/detail_/test_state/must_print)
include(cmake_test/detail_/test_state/post_test_asserts)
include(cmake_test/detail_/test_state/print)
include(cmake_test/detail_/test_state/should_pass)
include(cmake_test/detail_/test_state/title)


## @class TestState test_state cmake_test/detail_/test_state.cmake
#
#  @brief Class for holding the state of the test
#
#  The TestState class holds the state of the test that is currently being
#  parsed. While we document and use it as if it is a class it is important to
#  realize it's not really a class (even in the CMakePP object sense). The
#  decision to not use a CMakePP object was made in order to keep CMakeTest
#  stand alone.
#
#  To access a member function from outside the class use the syntax:
#
#  ```.cmake
#  test_state(<fxn_name> <arg1> <arg2> ...)
#  ```
#
#  where `<fxn_name>` is the name of the function as listed in the documentation
#  and the various `<argX>` are the arguments to the function. Internal
#  references should go through the normal function call.
#
#  @param[in] fxn The member function to call.
macro(test_state fxn)
    if("${fxn}" STREQUAL "CTOR")
        _ct_test_state_ctor(${ARGN})
    elseif("${fxn}" STREQUAL "TITLE")
        _ct_test_state_get_title(${ARGN})
    elseif("${fxn}" STREQUAL "PRINT")
        _ct_test_state_print(${ARGN})
    elseif("${fxn}" STREQUAL "ADD_CONTENT")
        _ct_test_state_add_content(${ARGN})
    elseif("${fxn}" STREQUAL "ADD_SECTION")
        _ct_test_state_add_section(${ARGN})
    elseif("${fxn}" STREQUAL "END_SECTION")
        _ct_test_state_end_section(${ARGN})
    elseif("${fxn}" STREQUAL "GET_CONTENT")
        _ct_test_state_get_content(${ARGN})
    elseif("${fxn}" STREQUAL "POST_TEST_ASSERTS")
        _ct_test_state_post_test_asserts(${ARGN})
    elseif("${fxn}" STREQUAL "SHOULD_PASS")
        _ct_test_state_should_pass(${ARGN})
    elseif("${fxn}" STREQUAL "MUST_PRINT")
        _ct_test_state_must_print(${ARGN})
    else()
        message(FATAL_ERROR "Class TestState has no member: ${fxn}")
    endif()
endmacro()
