
###############
overrides.cmake
###############

.. module:: overrides.cmake


.. function:: message()

   

   This function overrides the standard message() function to convert fatal_errors into CMakePP GENERIC_ERROR exceptions.

   This is useful for executing tests which are expected to fail without requiring subprocesses.

   If the first argument is not FATAL_ERROR, this function will behave exactly as the original message().

   


.. function:: ct_exit()

   

   This function will cause the CMake interpreter to stop processing immediately and it will throw a stack trace. There is unfortunately no way to silence the stacktrace.

   Details of why the interpreter was exited may be entered as the first argument to this function.

   

   :param ARGV0: The first argument is optional. If specified, ARGV0 is used for the details of the exit message.

   

