include_guard()

#[[
# This function encapsulates the process of getting CMakePP using CMake's
# FetchContent module. We have encapsulated it in a function so we can set
# the options for its configure step without affecting the options for the
# parent project's configure step (namely we do not want to build CMakePP's
# unit tests).
#]]
function(get_cmaize)
    include(cmaize/cmaize OPTIONAL RESULT_VARIABLE cmaize_found)
    if(NOT cmaize_found)
        # Store whether we are building tests or not, then turn off the tests
        set(build_testing_old "${BUILD_TESTING}")
        set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
        # Download CMakePP and bring it into scope
        include(FetchContent)
        FetchContent_Declare(
            cmaize
            GIT_REPOSITORY https://github.com/CMakePP/CMaize
        )
        FetchContent_MakeAvailable(cmaize)

        set(
            CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${cmake_test_SOURCE_DIR}/cmake"
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
