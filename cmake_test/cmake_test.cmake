include_guard()

# Allows us to capture the root directory of the CMakeTest module
set(_CT_CMAKE_TEST_ROOT ${CMAKE_CURRENT_LIST_DIR})

# Despite the way a unit test looks to the user, this is the only module the
# user needs to load.
include(cmake_test/add_test)
