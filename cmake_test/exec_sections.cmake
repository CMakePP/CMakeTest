include_guard()

#[[[
# Execute sections of a test. This will be called directly after running the enclosing test.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#]]
function(ct_exec_sections)
    #Get the identifier for the current execution unit (test/section/subsection)
    cpp_get_global(_es_original_unit "CT_CURRENT_EXECUTION_UNIT")
    cpp_get_global(_es_unit_sections "CMAKETEST_TEST_${_es_original_unit}_SECTIONS")
    foreach(_es_curr_section IN LISTS _es_unit_sections)


        #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_es_original_unit}_${_es_curr_section}")
        cpp_get_global(_es_friendly_name "CMAKETEST_TEST_${_es_original_unit}_${_es_curr_section}_FRIENDLY_NAME")




        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}.cmake" "${_es_curr_section}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_es_curr_section}.cmake")
        cpp_get_global(_es_exceptions "${_es_original_unit}_${_es_curr_section}_EXCEPTIONS")
        #get_property(ct_exception_details GLOBAL PROPERTY "${ct_original_unit}_${curr_section}_EXCEPTION_DETAILS")
        cpp_get_global(_es_expect_fail "CMAKETEST_TEST_${_es_original_unit}_${_es_curr_section}_EXPECTFAIL")
        #message(STATUS "Executing section named \"${_es_friendly_name}\", expectfail=${_es_expect_fail}")

        if(_es_expect_fail)
            if("${_es_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Section named \"${_es_friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")
                set(_es_section_fail "TRUE")
            endif()

        else()
            if(NOT "${_es_exceptions}" STREQUAL "")
                foreach(_es_exc IN LISTS _es_exceptions)
                    message("${CT_BoldRed}Section named \"${_es_friendly_name}\" raised exception:")
                    message("${_es_exc}${CT_ColorReset}")
                endforeach()
                set(_es_section_fail "TRUE")
           endif()
       endif()
       if(_es_section_fail)
            _ct_print_fail("${_es_friendly_name}" 1)
            cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
        else()
            _ct_print_pass("${_es_friendly_name}" 1)
        endif()
        ct_exec_sections()

    endforeach()
    cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_es_original_unit}")


endfunction()
