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
include(cmake_test/detail_/utilities/return)

#[[[ Makes the provided name more filesystem friendly
#
# CMakeTest will need to turn test names into file names in a few places. This
# requires the test name to be filesystem friendly. More specifically we:
#
# - Make the string lowercase
# - Replace spaces with underscores
# - Replace colons with hyphens
#
# :param _sn_new_name: An identifier to which the new name will be assigned
# :type _sn_new_name: Identifier
# :param _sn_old_name: The string that we are sanitizing.
# :type _sn_old_name: str
# :returns: A string containing the sanitized name. The result is accessible to
#           the caller via ``_sn_new_name``.
#]]
function(_ct_sanitize_name _sn_new_name _sn_old_name)
    string(TOLOWER "${_sn_old_name}" _sn_old_name)
    string(REPLACE " " "_" ${_sn_new_name} "${_sn_old_name}")
    string(REPLACE ":" "-" ${_sn_new_name} "${${_sn_new_name}}")
    string(MAKE_C_IDENTIFIER "${${_sn_new_name}}" "${_sn_new_name}")
    _ct_return(${_sn_new_name})
endfunction()
