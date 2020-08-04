cmake_policy(SET CMP0002 OLD) #Allow duplicate targets by overriding, needed for multiple tests that work with the same target

function(add_cmake_test_test)
    foreach(testi ${ARGN})
        include(${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
    endforeach()
endfunction()

add_subdirectory(asserts)
#add_subdirectory(detail_)
#add_subdirectory(tutorials)
ct_exec_tests()
cpp_get_global(did_tests_pass "CMAKETEST_TESTS_DID_PASS")

if(NOT did_tests_pass)
    ct_exit("Testing of CMakeTest failed")
endif()
