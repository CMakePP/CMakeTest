cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()

include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/cmake/get_cmaize.cmake")

#Sets print length to cached variable. This value is propagated
#to all tests but can be overriden with subsequent calls or
#via PRINT_LENGTH option to ct_add_test() and ct_add_section()
#Added for user convenience.
set(CT_DEFAULT_PRINT_LENGTH 80 CACHE STRING "The default print length for pass/fail lines. Can be overriden by individual tests.")
ct_set_print_length("${CT_DEFAULT_PRINT_LENGTH}")

set(CMAKEPP_LANG_DEBUG_MODE ON)

ct_add_dir("./cmake_test" CT_DEBUG_MODE_ON)
ct_add_dir("./test_directory_2" CT_DEBUG_MODE_ON)
