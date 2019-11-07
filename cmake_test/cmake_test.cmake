include_guard()

# Allows us to capture the root directory of the CMakeTest module
set(_CT_CMAKE_TEST_ROOT ${CMAKE_CURRENT_LIST_DIR})

# Despite the way a unit test looks to the user, this is the only module the
# user needs to load.
include(cmake_test/add_test)

#[[[ Convenience function for users of CMakeTest to add their tests to CTest
#
# The majority of CMakeTest focuses on having a unit testing framework for code
# written in the CMake language. Once users have written those unit tests they
# still need a way to register those unit tests with CTest (assuming they are
# using CTest for running their unit tests). That's what this function does.
# Given the value of ``CMAKE_MODULE_PATH`` for the unit tests and a list of
# files containing unit tests, this function registers those unit tests with
# CTest. Each unit test is assumed to reside in the current directory in a file
# ``<unit_test_name>.cmake``.
#
# :param module_path: List of filepaths to use
# :type module_path: list(paths)
# :param *args: The names of the files containing unit tests, without the
#               ``.cmake`` extension.
# :type *args: str
#]]
function(add_cmake_unit_tests module_path)
    string(REGEX REPLACE ";" "\\\;" test_path "${module_path}")
    foreach(testi ${ARGN})
        set(full_path ${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
        add_test(
            NAME "${testi}"
            COMMAND ${CMAKE_COMMAND}
                    -DCMAKE_MODULE_PATH=${test_path} -P ${full_path}
        )
    endforeach()
endfunction()
