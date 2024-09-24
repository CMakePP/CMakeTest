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
# :keyword CT_DEBUG_MODE_ON: Enables debug mode when the tests are run.
# :type CT_DEBUG_MODE_ON: bool
# :keyword USE_REL_PATH_NAMES: Enables using shorter, relative paths for
#                              test names, but increases the chance of name
#                              collisions.
# :type USE_REL_PATH_NAMES: bool
# :keyword LABEL: Use relative directory name for CTest label for all the tests
#                 in the directory.
#                 Run a group of labeled tests with `ctest -L <label>`
# :type LABEL: bool
# :keyword LABEL_NAME: CTest label for all the tests in the directory.
#                      Run a group of labeled tests with `ctest -L <label>`.
#                      This argument has higher priority than LABEL
# :type LABEL_NAME: str
# :keyword CMAKE_OPTIONS: List of additional CMake options to be
#                         passed to all test invocations. Options
#                         should follow the syntax:
#                         :code:`-D<variable_name>=<value>`
# :type CMAKE_OPTIONS: list
#]]
function(ct_add_dir _ad_test_dir)
    set(_ad_multi_value_args "CMAKE_OPTIONS")
    # TODO: This name is potentially misleading because it seems to enable
    #       debug mode for the test projects (see the use of 'ct_debug_mode'
    #       in cmake/cmake_test/templates/test_project_CMakeLists.txt.in).
    #       I propose renaming it to something like "ENABLE_DEBUG_MODE_IN_TESTS".
    set(_ad_options CT_DEBUG_MODE_ON USE_REL_PATH_NAMES LABEL)
    cmake_parse_arguments(PARSE_ARGV 1 ADD_DIR "${_ad_options}" "LABEL_NAME" "${_ad_multi_value_args}")

    # This variable will be picked up by the template
    # TODO: This variable should be made Config File-specific and may end up
    #       mirroring the rename of CT_DEBUG_MODE_ON above, if that happens
    set(ct_debug_mode "${ADD_DIR_CT_DEBUG_MODE_ON}")

    # We expect to be given relative paths wrt the project, like
    # ``ct_add_dir("test")``. This ensures we have an absolute path
    # to the test directory as well as a CMak-style normalized path.
    get_filename_component(_ad_abs_test_dir "${_ad_test_dir}" REALPATH)
    file(TO_CMAKE_PATH "${_ad_abs_test_dir}" _ad_abs_test_dir)

    # Recurse over the test directory to find all cmake files
    # (assumed to all be test files)
    file(GLOB_RECURSE
        _ad_test_files
        LIST_DIRECTORIES FALSE
        FOLLOW_SYMLINKS "${_ad_abs_test_dir}/*.cmake"
    )

    # Each test file will get its own directory and "mini-project" in the
    # build directory to facilitate independently running each test case.
    # These directories are created from hashes of the test directory and
    # test file paths to help ensure that each path is unique
    foreach(_ad_test_file ${_ad_test_files})
        # Set the test file path for configuring the test mini-project
        set(_CT_CMAKELISTS_TEMPLATE_TEST_FILE "${_ad_test_file}")

        # Sanitize the full path to the test file to get the mini-project name
        # for configuring the test mini-project
        cpp_sanitize_string(
            _CT_CMAKELISTS_TEMPLATE_PROJECT_NAME "${_ad_test_file}"
        )

        # Find the relative path to the test file from the test directory to
        # reduce the length of the test names
        file(RELATIVE_PATH
            _ad_test_file_rel_path
            "${_ad_abs_test_dir}"
            "${_ad_test_file}"
        )

        # Mangle the test directory and test file paths, since path strings
        # commonly have characters that are illegal in file names
        cpp_sanitize_string(_ad_test_dest_prefix "${_ad_abs_test_dir}")
        cpp_sanitize_string(_ad_test_proj_dir "${_ad_test_file_rel_path}")

        # Get hashes for the prefix directory and test project directory
        string(SHA256 _ad_test_dest_prefix_hash "${_ad_test_dest_prefix}")
        string(SHA256 _ad_test_proj_dir_hash "${_ad_test_proj_dir}")

        # Truncate the hashes to 7 characters
        set(_ad_hash_length 7)
        string(SUBSTRING 
            "${_ad_test_dest_prefix_hash}"
            0
            "${_ad_hash_length}"
            _ad_test_dest_prefix_hash
        )
        string(SUBSTRING 
            "${_ad_test_proj_dir_hash}"
            0
            "${_ad_hash_length}"
            _ad_test_proj_dir_hash
        )

        # Create the test destination path in the build directory
        set(_ad_test_dest_full_path
            "${CMAKE_CURRENT_BINARY_DIR}/tests/${_ad_test_dest_prefix_hash}/${_ad_test_proj_dir_hash}"
        )

        # Configure the CMakeLists.txt for test in the build directory
        configure_file(
            "${_CT_TEMPLATES_DIR}/test_CMakeLists.txt.in"
            "${_ad_test_dest_full_path}/src/CMakeLists.txt"
            @ONLY
        )

        if (ADD_DIR_USE_REL_PATH_NAMES)
            # Option 1 - shortest but highest collision likelyhood
            # Prepend the test name to the relative path to test file from the
            # given test directory

            # set(_ad_test_name "${}/${_ad_test_file_rel_path}")


            # Option 2 - longest but least collision likelyhood
            # Get the path from the root of the project, with the project name
            # prepended

            # Generate relative path from project root for the test name
            # file(RELATIVE_PATH
            #     _ad_test_file_rel_path_from_proj_root
            #     "${PROJECT_SOURCE_DIR}"
            #     "${_ad_test_file}"
            # )
            # # Prepend the project name to the relative path
            # set(_ad_test_name "${PROJECT_NAME}/${_ad_test_file_rel_path_from_proj_root}")


            # Option 3 - in-between length and collision likelyhood
            # Prepend the project name and given test directory name to the
            # test file relative path
            
            get_filename_component(_ad_test_dir_name "${_ad_test_dir}" NAME)
            set(_ad_test_name "${PROJECT_NAME}::${_ad_test_dir_name}/${_ad_test_file_rel_path}")
        else()
            set(_ad_test_name "${_ad_test_file}")
        endif()
        add_test(
            NAME
                "${_ad_test_name}"
            COMMAND
                "${CMAKE_COMMAND}"
                -S "${_ad_test_dest_full_path}/src"
                -B "${_ad_test_dest_full_path}"
                ${ADD_DIR_CMAKE_OPTIONS}
        )
        if(ADD_DIR_LABEL_NAME)
            set_property(TEST "${_ad_test_name}" PROPERTY LABELS "${ADD_DIR_LABEL_NAME}")
        elseif(ADD_DIR_LABEL)
            set_property(TEST "${_ad_test_name}" PROPERTY LABELS "${_ad_test_dir}")
        endif()
    endforeach()
endfunction()
