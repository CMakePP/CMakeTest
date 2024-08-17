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
#    and including it automatically pulls in CMaize through
#    FetchContent.
#]]

include_guard()
include(versions)

#[[
# This function encapsulates the process of getting CMaize using CMake's
# FetchContent module. We have encapsulated it in a function so we can set
# the options for its configure step without affecting the options for the
# parent project's configure step (namely we do not want to build CMaize's
# unit tests).
#]]
function(get_cmaize)
    include(cmaize/cmaize OPTIONAL RESULT_VARIABLE cmaize_found)
    if(NOT cmaize_found)
        # Store whether we are building tests or not, then turn off the tests
        set(build_testing_old "${BUILD_TESTING}")
        set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
        # Download CMaize and bring it into scope
        include(FetchContent)
        FetchContent_Declare(
            cmaize
            GIT_REPOSITORY https://github.com/CMakePP/CMaize
            GIT_TAG ${CMAIZE_VERSION}
        )
        FetchContent_MakeAvailable(cmaize)

        set(
            CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${cmaize_SOURCE_DIR}/cmake"
            PARENT_SCOPE
        )

        # Restore the previous value
        set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
    endif()
endfunction()

# Call the function we just wrote to get CMaize
get_cmaize()

# Include CMaize
include(cmaize/cmaize)
