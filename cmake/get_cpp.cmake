include_guard()

#[[
# This function encapsulates the process of getting CMakePP using CMake's
# FetchContent module. We have encapsulated it in a function so we can set
# the options for its configure step without affecting the options for the
# parent project's configure step (namely we do not want to build CMakePP's
# unit tests).
#]]
function(get_cpp)

    # Store whether we are building tests or not, then turn off the tests
    set(build_testing_old "${BUILD_TESTING}")
    set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

    # Download CMakePP and bring it into scope
    include(FetchContent)
    FetchContent_Declare(
         cpp
         GIT_REPOSITORY https://github.com/CMakePP/CMakePackagingProject
    )
    FetchContent_MakeAvailable(cpp)

    # Restore the previous value
    set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
endfunction()

# Call the function we just wrote to get CMakePP
get_cpp()

# Include CMakePP
include(cpp/cpp)
