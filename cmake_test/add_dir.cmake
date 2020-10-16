include_guard()
set(_ct_add_dir_file_dir "${CMAKE_CURRENT_LIST_DIR}")


function(ct_add_dir dir)
    file(GLOB _atd_files  "${dir}/*.cmake") #"${dir}/CMakeLists.txt")
    message("Files: ${_atd_files}")
    foreach(_atd_test_file ${_atd_files})
        file(RELATIVE_PATH _atd_rel_path 
        #include(${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
        configure_file("${_ct_add_dir_file_dir}/template_lists.txt" "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}/src/CMakeLists.txt" @ONLY)
        add_test(
        NAME
            ${testi}
        COMMAND
            "${CMAKE_CTEST_COMMAND}"
                --build-and-test "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}/src"
                                 "${CMAKE_CURRENT_BINARY_DIR}/tests/${testi}"
                --build-generator "${CMAKE_GENERATOR}"
                --test-command "${CMAKE_CTEST_COMMAND}"
        )
    endforeach()
endfunction()
