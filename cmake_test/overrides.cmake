# FIXME convert to doccomment when CMinx w/ module support is released

#[[ @module
#
# .. warning::
#    Including this module will override the default :code:`message()` implementation.
#]]

include_guard()


#[[[
# This function overrides the standard message() function to convert fatal_errors into CMakePP GENERIC_ERROR exceptions.
# This is useful for executing tests which are expected to fail without requiring subprocesses.
# If the first argument is not FATAL_ERROR, this function will behave exactly as the original message().
#]]
function(message)
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
endfunction()


#[[[
# This function will cause the CMake interpreter to stop processing immediately and it will throw a stack trace. There is unfortunately no way to silence the stacktrace.
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
