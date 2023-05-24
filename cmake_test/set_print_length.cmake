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

#[[[
# Wrapper macro to set CT_PRINT_LENGTH variable in current scope.
# This length can be overriden by setting `PRINT_LENGTH`
# in `ct_add_test()` or `ct_add_section()`
#
# Priority for print length is as follows (first most important):
#  1. Current execution unit's PRINT_LENGTH option
#  2. Parent's PRINT_LENGTH option
#  3. Length set by ct_set_print_length()
#  4. Built-in default of 80.
#
# :param length: Length for pass/fail print lines.
# :type length: int
#]]
macro(ct_set_print_length _spl_length)
   set(CT_PRINT_LENGTH "${_spl_length}")
endmacro()
