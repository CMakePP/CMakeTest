

set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
ctest_start(Experimental "." "build")

include(CMakeTest.cmake)

#ctest_configure(BUILD build/ SOURCE . CAPTURE_CMAKE_ERROR err)
#message("${err}")

#ctest_start(Experimental "Test_Source" "build_test")
#ctest_configure(BUILD build_test SOURCE Test_Source CAPTURE_CMAKE_ERROR err)
#message("${err}")
