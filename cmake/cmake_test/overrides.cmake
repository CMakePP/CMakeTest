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
#
# .. warning::
#    Including this module will override the default :code:`message()` implementation.
#
# .. attention::
#    This module is intended for internal use only
#]]

include_guard(GLOBAL)


#[[[
# This function overrides the standard message() function to convert fatal_errors into CMakePP GENERIC_ERROR exceptions.
# This is useful for executing tests which are expected to fail without requiring subprocesses.
# If the first argument is not FATAL_ERROR, this function will behave exactly as the original message().
#]]
function(message)
    # Set debug mode to what it should be for cmaketest, in case the test changed it
    set(_m_temp_debug_mode "${CMAKEPP_LANG_DEBUG_MODE}")
    cpp_get_global(_m_ct_debug_mode "CT_DEBUG_MODE")
    set(CMAKEPP_LANG_DEBUG_MODE "${_m_ct_debug_mode}")
    if(ARGC GREATER 1)
        set(_msg_message_with_level "${ARGV}")
        list(REMOVE_AT _msg_message_with_level 0)
        cpp_set_global(CT_LAST_MESSAGE "${_msg_message_with_level}")
        if(ARGV0 STREQUAL "FATAL_ERROR")
            cpp_get_global(_m_exception_handlers "_CPP_EXCEPTION_HANDLERS_")
            cpp_map(GET "${_m_exception_handlers}" _m_handlers_list "GENERIC_ERROR")
            cpp_map(GET "${_m_exception_handlers}" _m_all_handlers_list "ALL_EXCEPTIONS")
            if("${_m_handlers_list}" STREQUAL "" AND "${_m_all_handlers_list}" STREQUAL "" )
                #No handlers set, will cause infinite recursion if we raise error
                #so force terminate
                ct_exit("Uncaught exception: ${ARGN}")

            else()
                cpp_raise(GENERIC_ERROR "${ARGV1}")
                set(CMAKEPP_LANG_DEBUG_MODE "${_m_temp_debug_mode}")
                return()
            endif()
        endif()

    else()
        cpp_set_global(CT_LAST_MESSAGE "${ARGV}")
    endif()

    if("${ARGV}" STREQUAL "")
        _message("")
    else()
        _message(${ARGV})
    endif()

    set(CMAKEPP_LANG_DEBUG_MODE "${_m_temp_debug_mode}")
endfunction()


#[[[
# This function will cause the CMake interpreter to stop processing immediately and it will throw a stack trace.
# There is unfortunately no way to silence the stacktrace.
# Details of why the interpreter was exited may be entered as the first argument to this function.
#
# :param ARGV0: The first argument is optional. If specified, ARGV0 is used for the details of the exit message.
#]]
function(ct_exit)
    if(ARGC GREATER 0)
        set(msg "${CT_BoldRed}Testing forcibly stopped, no further tests will be executed. Details: ${ARGV0}${CT_ColorReset}")
    else()
        set(msg "${CT_BoldRed}Testing forcibly stopped, no further tests will be executed.${CT_ColorReset}")

    endif()
    _message(FATAL_ERROR "${msg}")
endfunction()
