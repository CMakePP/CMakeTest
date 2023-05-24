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

##[[[ Case-insensitive search for a substring.
#
# This function will search through the string ``${_lf_string}`` for the
# substring ``${_lf_substring}``. If the substring is found than the identifier
# provided as ``${_lf_found}`` will be set to ``TRUE`` otherwise it will be set
# to ``FALSE``.
#
# :param found: Identifier to hold the result.
# :type found: Identifier
# :param substring: The substring we are looking for.
# :type substring: str
# :param string: The string we are searching for ``${_lf_substring}`` in.
# :type string: str
# :returns: ``TRUE`` if the substring is found and ``FALSE`` otherwise. Result
#           is accessible to the caller via ``found``.
#]]
function(_ct_lc_find _lf_found _lf_substring _lf_string)
    string(TOLOWER "${_lf_string}" _lf_lc_string)
    string(TOLOWER "${_lf_substring}" _lf_lc_substring)

    string(FIND "${_lf_lc_string}" "${_lf_lc_substring}" _lf_pos)
    set(${_lf_found} TRUE PARENT_SCOPE)
    if("${_lf_pos}" STREQUAL "-1")
        set(${_lf_found} FALSE PARENT_SCOPE)
    endif()
endfunction()


