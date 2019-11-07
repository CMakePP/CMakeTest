cmake_minimum_required(VERSION 3.10) #Use include_guard()
project(CMakeTest VERSION 1.0.0)

if("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
    message(
        FATAL_ERROR
        "In-source builds are disabled. Please rerun cmake specifying a build "
        "directory. The easiest way to do this is:\n"
        "cmake -B<build_directory> ...\n"
        "Also please note that this invocation has created the file:\n "
        "${PROJECT_SOURCE_DIR}/CMakeCache.txt\n"
        "and the directory:\n"
        "${PROJECT_SOURCE_DIR}/CMakeFiles\n They should be deleted "
        "before you run cmake again."
    )
endif()

option(BUILD_TESTS "Should we build and run the unit tests?" TRUE)
install(
    DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/cmake_test
    DESTINATION  cmake
    MESSAGE_NEVER
    FILES_MATCHING PATTERN "*.cmake"
)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
