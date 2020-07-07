include_guard()


#[[[
# This function overrides the standard message() function to convert fatal_errors into CMakePP GENERIC_ERROR exceptions.
# This is useful for executing tests which are expected to fail without requiring subprocesses.
# If the first argument is not FATAL_ERROR, this function will behave exactly as the original message().
#]]
function(message)
    if(ARGC GREATER 1 AND ARGV0 STREQUAL "FATAL_ERROR")
        cpp_raise(GENERIC_ERROR "${ARGV1}")
        return()
    endif()
    _message(${ARGV})
endfunction()


#[[[
# This function will cause the CMake interpreter to stop processing immediately and it will throw a stack trace. There is unfortunately no way to silence the stacktrace.
# Details of why the interpreter was exited may be entered as the first argument to this function.
#]]
function(exit)
    if(ARGC GREATER 0)
        set(msg "Testing forcibly stopped, no further tests will be executed. Details: ${ARGV0}")
    else()
        set(msg "Testing forcibly stopped, no further tests will be executed.")

    endif()
    _message(FATAL_ERROR msg)
endfunction()
