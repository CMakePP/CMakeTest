function(ct_exec_subsections)

    #Execute the section again, this time executing subsections. Only do when not executing expectfail
    cpp_set_global("CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXECUTE_SECTIONS" TRUE)
    include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")

endfunction()
