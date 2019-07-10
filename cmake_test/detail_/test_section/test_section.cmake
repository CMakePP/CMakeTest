include_guard()
include(cmake_test/detail_/test_section/add_content)
include(cmake_test/detail_/test_section/add_section)
include(cmake_test/detail_/test_section/ctor)
include(cmake_test/detail_/test_section/end_section)
include(cmake_test/detail_/test_section/get_content)
include(cmake_test/detail_/test_section/must_print)
include(cmake_test/detail_/test_section/post_test_asserts)
include(cmake_test/detail_/test_section/print)
include(cmake_test/detail_/test_section/should_pass)
include(cmake_test/detail_/test_section/title)


## @class TestSection test_section cmake_test/detail_/test_section.cmake
#
#  @brief Class for holding a section of the unit test
#
#  The TestSection class holds a section of the test that is currently being
#  parsed. While we document and use it as if it is a class it is important to
#  realize it's not really a class (even in the CMakePP object sense). The
#  decision to not use a CMakePP object was made in order to keep CMakeTest
#  stand alone.
#
#  To access a member function from outside the class use the syntax:
#
#  ```.cmake
#  test_section(<fxn_name> <arg1> <arg2> ...)
#  ```
#
#  where `<fxn_name>` is the name of the function as listed in the documentation
#  and the various `<argX>` are the arguments to the function. Internal
#  references should go through the normal function call.
#
#  @param[in] fxn The member function to call.
macro(test_section fxn)
    if("${fxn}" STREQUAL "CTOR")
        _ct_test_section_ctor(${ARGN})
    elseif("${fxn}" STREQUAL "TITLE")
        _ct_test_section_get_title(${ARGN})
    elseif("${fxn}" STREQUAL "PRINT")
        _ct_test_section_print(${ARGN})
    elseif("${fxn}" STREQUAL "ADD_CONTENT")
        _ct_test_section_add_content(${ARGN})
    elseif("${fxn}" STREQUAL "ADD_SECTION")
        _ct_test_section_add_section(${ARGN})
    elseif("${fxn}" STREQUAL "END_SECTION")
        _ct_test_section_end_section(${ARGN})
    elseif("${fxn}" STREQUAL "GET_CONTENT")
        _ct_test_section_get_content(${ARGN})
    elseif("${fxn}" STREQUAL "POST_TEST_ASSERTS")
        _ct_test_section_post_test_asserts(${ARGN})
    elseif("${fxn}" STREQUAL "SHOULD_PASS")
        _ct_test_section_should_pass(${ARGN})
    elseif("${fxn}" STREQUAL "MUST_PRINT")
        _ct_test_section_must_print(${ARGN})
    else()
        message(FATAL_ERROR "Class TestSection has no member: ${fxn}")
    endif()
endmacro()