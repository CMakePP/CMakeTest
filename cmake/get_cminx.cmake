include_guard()

#[[
# This function encapsulates the process of getting CMinx using CMake's
# FetchContent module. We have encapsulated it in a function so we can set
# the options for its configure step without affecting the options for the
# parent project's configure step (namely we do not want to build CMinx's
# unit tests).
#]]
function(get_cminx)
    include(cminx OPTIONAL RESULT_VARIABLE cminx_found)
    if(NOT cminx_found)

        # Store whether we are building docs or not, then turn off the docs gen
        set(build_docs_old "${BUILD_DOCS}")
        set(BUILD_DOCS OFF CACHE BOOL "" FORCE)


        # Store whether we are building tests or not, then turn off the tests
        set(build_testing_old "${BUILD_TESTING}")
        set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
        # Download CMakePP and bring it into scope
        include(FetchContent)
        FetchContent_Declare(
             cminx
             GIT_REPOSITORY https://github.com/CMakePP/CMinx.git
       )
       FetchContent_MakeAvailable(cminx)
       FetchContent_GetProperties(cminx)
       list(APPEND CMAKE_MODULE_PATH "${cminx_SOURCE_DIR}/cmake")
       set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING "" FORCE)
       # Restore the previous value
       set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)
       set(BUILD_DOCS "${build_docs_old}" CACHE BOOL "" FORCE)
    endif()
endfunction()

# Call the function we just wrote to get CMinx
get_cminx()

# Include CMinx
include(cminx)
