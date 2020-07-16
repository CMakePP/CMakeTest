include_guard()

#[[[
# Execute sections of a test. This will be called directly after running the enclosing test.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#]]
function(ct_exec_sections)
    #Get the identifier for the current execution unit (test/section/subsection)
    get_property(ct_original_unit GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT")
    get_property(unit_sections GLOBAL PROPERTY "CMAKETEST_TEST_${ct_original_unit}_SECTIONS")
    foreach(curr_section IN LISTS unit_sections)


        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${ct_original_unit}_${curr_section}")
        get_property(friendly_name GLOBAL PROPERTY "CMAKETEST_TEST_${ct_original_unit}_${curr_section}_FRIENDLY_NAME")

        #message(STATUS "Executing section named \"${friendly_name}\"")


        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${curr_section}.cmake" "${curr_section}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/sections/${curr_section}.cmake")
        get_property(ct_exceptions GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTIONS")
        #get_property(ct_exception_details GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTION_DETAILS")
        get_property(expect_fail GLOBAL PROPERTY "CMAKETEST_TEST_${ct_original_unit}_${curr_section}_EXPECTFAIL")
        if(expect_fail)
            if("${ct_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Section named \"${friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")
                set(CMAKETEST_TEST_FAIL "TRUE")
            endif()

        else()
            if(NOT "${ct_exceptions}" STREQUAL "")
                foreach(exc IN LISTS ct_exceptions)
                    message("${CT_BoldRed}Section named \"${friendly_name}\" raised exception:")
                    message("${exc}${CT_ColorReset}")
                endforeach()
                set(CMAKETEST_TEST_FAIL "TRUE")
           endif()
       endif()
       if(CMAKETEST_TEST_FAIL)
            _ct_print_fail("${friendly_name}" 1)
        else()
            _ct_print_pass("${friendly_name}" 1)
        endif()
        ct_exec_sections()

    endforeach()
    set_property(GLOBAL PROPERTY "CT_CURRENT_EXECUTION_UNIT" "${ct_original_unit}")


endfunction()
