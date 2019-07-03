set(tutorials tutorials/1_hello_world.cmake
              tutorials/2_sections.cmake
              test_state.cmake
)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})

foreach(testi ${tutorials})
    add_test(
        NAME "${testi}"
        COMMAND ${CMAKE_COMMAND}
                "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"
                -P ${CMAKE_CURRENT_SOURCE_DIR}/${testi}
    )
endforeach()
