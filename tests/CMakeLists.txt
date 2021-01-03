cmake_minimum_required(VERSION "${_ct_min_cmake_version}") #Required for FetchContent_MakeAvailable()

project(CMakeTest LANGUAGES C) #Need C language so CMake doesn't complain about no linker language for some empty files used for tests
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../")
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)


#Enable colors in Unix environments, ignored on Windows. Will output garbage for pipes and text files
set(CMAKETEST_USE_COLORS "FALSE")

include(cmake_test/cmake_test)
include("${PROJECT_SOURCE_DIR}/../cmake/get_cpp.cmake")

#function(add_cmake_test_test)
#    foreach(testi ${ARGN})
        #include(${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
#        configure_file("${PROJECT_SOURCE_DIR}/../tests/template_lists.txt" "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}/src/CMakeLists.txt" @ONLY)
#        add_test(
#        NAME
#            ${testi}
#        COMMAND
#            "${CMAKE_CTEST_COMMAND}"
#                --build-and-test "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}/src"
#                                 "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}"
#                --build-generator "${CMAKE_GENERATOR}"
#                --test-command "${CMAKE_CTEST_COMMAND}"
#        )
#    endforeach()
#endfunction()

ct_add_dir("asserts")
#ct_add_dir("detail_")
#add_subdirectory(asserts)
#add_subdirectory(detail_)
#add_subdirectory(tutorials)
#ct_exec_tests()
#cpp_get_global(did_tests_pass "CMAKETEST_TESTS_DID_PASS")

#if(NOT did_tests_pass)
#    ct_exit("Testing of CMakeTest failed")
#endif()
