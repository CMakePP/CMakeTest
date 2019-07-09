function(add_cmake_test_test)
    foreach(testi ${ARGN})
        set(full_path ${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
        add_test(
            NAME "${testi}"
            COMMAND ${CMAKE_COMMAND}
            -DCMAKE_MODULE_PATH=${PROJECT_SOURCE_DIR}
            -P ${full_path}
        )
    endforeach()
endfunction()

add_subdirectory(detail_)
add_subdirectory(tutorials)
