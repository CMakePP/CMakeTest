cmake_minimum_required(VERSION 3.14) #Use include_guard()
project(CMakeTest VERSION 1.0.0 LANGUAGES NONE)
set(CMAKE_TEST_USE_COLORS "True")
#set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
#ctest_start(Experimental "." "build")


#set(CMAKE_CURRENT_BINARY_DIR "build")
#set(PROJECT_SOURCE_DIR ".")
include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")
get_filename_component(CMAKE_TEST_CURRENT_FILE "${PROJECT_SOURCE_DIR}/CMakeTest.cmake" ABSOLUTE)
set(_length 500)
set(_index 0) # The loop index
#while("${_index}" LESS "${_length}")
#    configure_file(CMakeTest.cmake "${CMAKE_CURRENT_BINARY_DIR}/CMakeTest_${_index}.cmake" @ONLY)
#    include("${CMAKE_CURRENT_BINARY_DIR}/CMakeTest_${_index}.cmake")
#    math(EXPR _index "${_index} + 1") #increment index
#endwhile()

include("examples/CMakeTest.cmake")
ct_exec_tests()
#ctest_configure(BUILD build/ SOURCE . CAPTURE_CMAKE_ERROR err)
#message("${err}")

#ctest_start(Experimental "Test_Source" "build_test")
#ctest_configure(BUILD build_test SOURCE Test_Source CAPTURE_CMAKE_ERROR err)
#message("${err}")
