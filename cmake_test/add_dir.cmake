\include_guard()
set(_ct_add_dir_file_dir "${CMAKE_CURRENT_LIST_DIR}")


function(ct_add_dir dir)
    get_filename_component(_atd_abs_test_dir "${dir}" REALPATH)
    file(GLOB_RECURSE _atd_files LIST_DIRECTORIES TRUE FOLLOW_SYMLINKS "${_atd_abs_test_dir}/*.cmake") #Recurse over target dir to find all cmake files

    foreach(_atd_test_file ${_atd_files})
        file(RELATIVE_PATH _atd_rel_path "${_atd_abs_test_dir}" "${_atd_test_file}") #Find rel path so we don't end up with insanely long paths under test folders

        configure_file("${_ct_add_dir_file_dir}/template_lists.txt" "${CMAKE_CURRENT_BINARY_DIR}/tests/${_atd_rel_path}/src/CMakeLists.txt" @ONLY) #Fill in boilerplate, copy to build dir
        add_test(
        NAME
            ${_atd_rel_path}
        COMMAND
            "${CMAKE_CTEST_COMMAND}"
                --build-and-test "${CMAKE_CURRENT_BINARY_DIR}/tests/${_atd_rel_path}/src"
                                 "${CMAKE_CURRENT_BINARY_DIR}/tests/${_atd_rel_path}"
                --build-generator "${CMAKE_GENERATOR}"
                --test-command "${CMAKE_CTEST_COMMAND}"
        ) #Register boilerplate with CTest
    endforeach()
endfunction()
