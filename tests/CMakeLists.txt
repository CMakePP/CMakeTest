set(tests tutorials/hello_world.cmake)
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})


foreach(testi ${tests})
    add_test(
        NAME "${testi}"
        COMMAND ${CMAKE_COMMAND}
                "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"
                -P ${CMAKE_CURRENT_SOURCE_DIR}/${testi}
    )
endforeach()
