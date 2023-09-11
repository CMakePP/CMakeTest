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

#[[[ @module
# This module serves as the main entry point into CMakeTest,
# it automatically includes all modules that are required to use it
# as well as setting extremely important path-related constants.
#]]

include_guard()

include(cmakepp_lang/cmakepp_lang)

#[[[
# Root of CMakeTest, used to
# locate important files during runtime.
#]]
set(_CT_CMAKE_TEST_ROOT ${CMAKE_CURRENT_LIST_DIR})

#[[[
# Directory where the template files are located.
#]]
set(_CT_TEMPLATES_DIR "${CMAKE_CURRENT_LIST_DIR}/templates")

#[[[
# Whether CMakeTest should run in debug mode,
# used to separate debugging for CMakeTest from
# debugging for the user-side test code.
#]]
cpp_set_global("CT_DEBUG_MODE" "${CMAKEPP_LANG_DEBUG_MODE}")

# Despite the way a unit test looks to the user, this is the only module the
# user needs to load.

include(cmake_test/set_print_length)
include(cmake_test/execution_unit)
include(cmake_test/detail_/utilities/print_result)
include(cmake_test/add_test)
include(cmake_test/add_section)
include(cmake_test/exec_tests)
include(cmake_test/colors)
include(cmake_test/overrides)
include(cmake_test/add_dir)
include(cmake_test/asserts/asserts)
include(cmake_test/register_exception_handler)
include(cmake_test/expectfail_subprocess)
