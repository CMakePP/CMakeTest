cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()

include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")

ct_add_dir(".")
