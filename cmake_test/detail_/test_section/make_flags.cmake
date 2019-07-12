include_guard()
include(cmake_test/cmake_test)
include(cmake_test/detail_/test_section/private)

## @memberof TestSection
#  @fn MAKE_FLAGS(handle, result, dir)
#  @brief Determines the flags for running CMake to test this section
#
#  Each section of a unit test is tested with a separate invocation of CMake.
#  This function assembles the flags which should be provided to the CMake
#  command used to run this section. Minimally this set of flags is:
#
#  - `-H<test_dir>` : sets the root of the configuration
#  - `-B<test_dir>/build` : sets the build directory
#  - `-DCMAKE_INSTALL_PREFIX=<test_dir>/install` : sets the install directory
#  - `-DCMAKE_MODULE_PATH=<...>` : path to CMakeTest and user-specified modules
#
#  The user can specify additional CMake flags, per test section, which will be
#  appended onto the  above list.
#
#  @param[in] handle The TestSection instance
#  @param[out] result The list of CMake flags
#  @param[in] dir The prefix where the test section's files will go
function(_ct_test_section_make_flags _tsmf_handle _tsmf_result _tsmf_dir)
    _ct_is_handle(_tsmf_handle)
    _ct_nonempty_string(_tsmf_result)
    _ct_nonempty_string(_tsmf_dir)

    # Get parent section's flags
    _ct_get_prop(${_tsmf_handle} _tsmf_parent "parent_section")
    if("${_tsmf_parent}" STREQUAL "0")
        set(${_tsmf_result} "-H${_tsmf_dir}/src")
        list(APPEND ${_tsmf_result} "-B${_tsmf_dir}/build_dir")
        list(
            APPEND ${_tsmf_result} "-DCMAKE_INSTALL_PREFIX=${_tsmf_dir}/install"
        )
        list(APPEND ${_tsmf_result} "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")
    else()
        _ct_test_section_make_flags(
           ${_tsmf_parent} ${_tsmf_result} ${_tsmf_dir}
        )
    endif()

    # Append our flags (if non-empty)
    _ct_get_prop(${_tsmf_handle} _tsmf_flags "cmake_var")
    if(NOT "${_tsmf_flags}" STREQUAL "")
        list(APPEND ${_tsmf_result} ${_tsmf_flags})
    endif()

    _ct_return(${_tsmf_result})
endfunction()
