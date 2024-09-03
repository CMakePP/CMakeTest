# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()

include(cmakepp_lang/cmakepp_lang)

#[[[
# This function will find all :code:`*.cmake` files in the specified directory
# as well as recursively through all subdirectories. It will then configure the
# boilerplate template to include() each cmake file and register each
# configured boilerplate with CTest. The configured templates will be executed
# seperately via CTest during the Test phase, and each *.cmake file found in
# the specified directory is assumed to contain CMakeTest tests.
#
# :param test_dir: The directory to search for *.cmake files containing tests.
#                  Subdirectories will be recursively searched.
# :type test_dir: path
#
# **Keyword Arguments**
#
# :keyword CMAKE_OPTIONS: List of additional CMake options to be
#                         passed to all test invocations. Options
#                         should follow the syntax:
#                         :code:`-D<variable_name>=<value>`
# :type CMAKE_OPTIONS: list
#]]
function(ct_add_dir _ad_test_dir)
    set(_ad_multi_value_args "CMAKE_OPTIONS")
    set(_ad_options CT_DEBUG_MODE_ON)
    cmake_parse_arguments(PARSE_ARGV 1 ADD_DIR "${_ad_options}" "" "${_ad_multi_value_args}")

    # This variable will be picked up by the template
    set(ct_debug_mode "${ADD_DIR_CT_DEBUG_MODE_ON}")

    # We expect to be given relative paths wrt the project, like
    # ``ct_add_dir("test")``. This ensures we have an absolute path
    # to the test directory when we do get a relative path. If we
    # get an absolute path to begin with, this is essentially a no-op.
    get_filename_component(_ad_abs_test_dir "${_ad_test_dir}" REALPATH)

    # Recurse over the test directory to find all cmake files
    # (assumed to all be test files)
    file(GLOB_RECURSE
        _ad_test_files
        LIST_DIRECTORIES FALSE
        FOLLOW_SYMLINKS "${_ad_abs_test_dir}/*.cmake"
    )

    # Each test file will get its own directory and "mini-project" in the
    # build directory to facilitate independently running each test case.
    # These directories are created from the mangled path to the source test
    # file in the project to help ensure that each path is unique
    foreach(_ad_test_file ${_ad_test_files})
        # Normalize the absolute path to the project test directory, used in
        # the build directory as a prefixing subdirectory to hold all of the
        # test mini-projects from this test directory
        file(TO_CMAKE_PATH "${_ad_abs_test_dir}" _ad_normalized_abs_test_dir)

        # Find the relative path to the test file from the test directory to
        # reduce the path length for the test folders created in the build
        # directory. This is used for the test mini-project directory in the
        # build directory
        file(RELATIVE_PATH
            _ad_test_file_rel_path
            "${_ad_abs_test_dir}"
            "${_ad_test_file}"
        )

        # string(REPLACE "/" "_" _ad_dir_prefix "${_ad_normalized_dir}")
        # string(REPLACE ":" "_" _ad_dir_prefix "${_ad_dir_prefix}")

        # Mangle all of the directory names derived from paths, since path
        # strings commonly have characters that are illegal in file names
        # mangle_path(_ad_dir_prefix_mangled "${_ad_normalized_abs_test_dir}")
        # mangle_path(_ad_rel_path_mangled "${_ad_test_file_rel_path}")
        cpp_sanitize_string(_ad_test_dest_prefix
            "${_ad_normalized_abs_test_dir}"
        )
        cpp_sanitize_string(_ad_test_proj_dir "${_ad_test_file_rel_path}")

        set(_ad_test_dest_full_path
            "${CMAKE_CURRENT_BINARY_DIR}/tests/${_ad_test_dest_prefix}/${_ad_test_proj_dir}"
        )

        # Fill in boilerplate, copy to build dir
        configure_file(
            "${_CT_TEMPLATES_DIR}/lists.txt"
            "${_ad_test_dest_full_path}/src/CMakeLists.txt"
            @ONLY
        )
        add_test(
        NAME
            "${_ad_test_dest_prefix}_${_ad_test_proj_dir}"
        COMMAND
            "${CMAKE_COMMAND}"
               -S "${_ad_test_dest_full_path}/src"
               -B "${_ad_test_dest_full_path}"
               ${ADD_DIR_CMAKE_OPTIONS}
        )
    endforeach()
endfunction()
