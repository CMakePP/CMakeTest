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
# This module simply includes all of the various
# assert modules, so one only has to include
# this file to have access to all CMakeTest asserts.
#
# Most (but not all) assertions come in two flavors:
# an affirmative assert and a negative assert. For example:
#
# ```
# ct_assert_defined(AN_IDENTIFIER)       # Fails if AN_IDENTIFIER is not defined
# ct_assert_not_defined(AN_IDENTIFIER)   # Fails if AN_IDENTIFIER is defined
# ```
#]]

include_guard()
include(cmake_test/asserts/defined)
include(cmake_test/asserts/equal)
include(cmake_test/asserts/file_contains)
include(cmake_test/asserts/file_exists)
include(cmake_test/asserts/list)
include(cmake_test/asserts/library_exists)
include(cmake_test/asserts/target_exists)
include(cmake_test/asserts/target_has_property)
include(cmake_test/asserts/true_false)
include(cmake_test/asserts/prints)
