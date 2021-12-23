include_guard()

include("cpp/cpp")

# Allows us to capture the root directory of the CMakeTest module
set(_CT_CMAKE_TEST_ROOT ${CMAKE_CURRENT_LIST_DIR})

#Capture the templates directory and expose as constant
set(_CT_TEMPLATES_DIR "${CMAKE_CURRENT_LIST_DIR}/templates")

# Despite the way a unit test looks to the user, this is the only module the
# user needs to load.

include(cmake_test/set_print_length)
include(cmake_test/detail_/utilities/print_result)
include(cmake_test/add_test)
include(cmake_test/add_section)
include(cmake_test/exec_tests)
include(cmake_test/exec_section)
include(cmake_test/exec_subsections)
include(cmake_test/colors)
include(cmake_test/overrides)
include(cmake_test/add_dir)
include(cmake_test/asserts/asserts)
include(cmake_test/register_exception_handler)
include(cmake_test/expectfail_subprocess)
