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
# .. warning::
#    This module is only used when building CMakeTest,
#    and including it automatically pulls in CMakePPLang through
#    FetchContent.
#]]

include_guard()
include(versions)

#[[
# This function encapsulates the process of getting CMakePPLang using CMake's
# FetchContent module. When CMaize supports find_or_build for CMake modules this
# file will be deprecated.
#]]
function(get_cmakepp_lang)
    include(
        cmakepp_lang/cmakepp_lang
        OPTIONAL
        RESULT_VARIABLE cmakepp_lang_found
    )
    if(NOT cmakepp_lang_found)
        # Store whether we are building tests or not, then turn off the tests
        set(build_testing_old "${BUILD_TESTING}")
        set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
        # Download CMakePPLang and bring it into scope
        include(FetchContent)
        FetchContent_Declare(
            cmakepp_lang
            GIT_REPOSITORY https://github.com/CMakePP/CMakePPLang
            GIT_TAG ${CMAKEPP_LANG_VERSION}
        )
        FetchContent_MakeAvailable(cmakepp_lang)

        set(
            CMAKE_MODULE_PATH
            "${CMAKE_MODULE_PATH}" "${cmakepp_lang_SOURCE_DIR}/cmake"
            PARENT_SCOPE
        )

        # Restore the previous value
        set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
    endif()
endfunction()

# Call the function we just wrote to get CMakePPLang
get_cmakepp_lang()

# Include CMakePPLang
include(cmakepp_lang/cmakepp_lang)
