include_guard()

#[[[
# This function will find all *.cmake files in the specified directory as well as recursively through all subdirectories.
# It will then configure the boilerplate template to include() each cmake file and register each configured boilerplate
# with CTest. The configured templates will be executed seperately via CTest during the Test phase, and each *.cmake
# file found in the specified directory is assumed to contain CMakeTest tests.
#
# :param _ad_dir: The directory to search for *.cmake files. Subdirectories will be recursively searched.
# :type _ad_dir: path
#
# **Keyword Arguments**
#
# :keyword CMAKE_OPTIONS: List of additional CMake options to be passed to all test invocations. Options should follow the syntax: :code:`-D<variable_name>=<value>`
# :type CMAKE_OPTIONS: list
#
#
#]]
function(ct_add_dir _ad_dir)
    set(_ad_multi_value_args "CMAKE_OPTIONS")
    cmake_parse_arguments(PARSE_ARGV 1 ADD_DIR "" "" "${_ad_multi_value_args}")

    get_filename_component(_ad_abs_test_dir "${_ad_dir}" REALPATH)
    file(GLOB_RECURSE _ad_files LIST_DIRECTORIES FALSE FOLLOW_SYMLINKS "${_ad_abs_test_dir}/*.cmake") #Recurse over target dir to find all cmake files

    foreach(_ad_test_file ${_ad_files})
        #Find rel path so we don't end up with insanely long paths under test folders
        file(RELATIVE_PATH _ad_rel_path "${_ad_abs_test_dir}" "${_ad_test_file}")
        cmake_path(CONVERT "${_ad_abs_test_dir}" TO_CMAKE_PATH_LIST _ad_normalized_dir NORMALIZE)
        string(REPLACE "/" "_" _ad_dir_prefix "${_ad_normalized_dir}")

        #Fill in boilerplate, copy to build dir
        configure_file(
            "${_CT_TEMPLATES_DIR}/lists.txt"
            "${CMAKE_CURRENT_BINARY_DIR}/tests/${_ad_dir_prefix}/${_ad_rel_path}/src/CMakeLists.txt"
            @ONLY
        )
        add_test(
        NAME
            "${_ad_dir_prefix}_${_ad_rel_path}"
        COMMAND
            "${CMAKE_COMMAND}"
               -S "${CMAKE_CURRENT_BINARY_DIR}/tests/${_ad_dir_prefix}/${_ad_rel_path}/src"
               -B "${CMAKE_CURRENT_BINARY_DIR}/tests/${_ad_dir_prefix}/${_ad_rel_path}"
               ${ADD_DIR_CMAKE_OPTIONS}
        )

    endforeach()
endfunction()
