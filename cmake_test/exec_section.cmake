function(ct_exec_section)

    cpp_get_global(_as_old_section_depth "CMAKETEST_SECTION_DEPTH")
    math(EXPR _as_new_section_depth "${_as_old_section_depth} + 1")
    cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_new_section_depth}")
    #Set the new execution unit so that the exceptions can be tracked and new subsections executed properly
    cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}_${_as_curr_section}")
    cpp_get_global(_as_friendly_name "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_FRIENDLY_NAME")



    cpp_get_global(_as_expect_fail "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_EXPECTFAIL")
    cpp_get_global(_as_print_length "CMAKETEST_TEST_${_as_curr_exec_unit}_${${CT_ADD_SECTION_NAME}}_PRINT_LENGTH")


    if(_as_expect_fail) #If this section expects to fail

        if(NOT _as_exec_expectfail) #We're in main interpreter so we need to configure and execute the subprocess
            ct_expectfail_subprocess("${_as_curr_exec_unit}" "${_as_curr_section}")
        else() #We're in subprocess
            file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake" "${_as_curr_section}()")
            include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")
            cpp_get_global(_as_exceptions "${_as_original_unit}_${_as_curr_section}_EXCEPTIONS")

            if(NOT "${_as_exceptions}" STREQUAL "")
                foreach(_as_exc IN LISTS _as_exceptions)
                    message("${CT_BoldRed}Section named \"${_as_friendly_name}\" raised exception:")
                    message("${_as_exc}${CT_ColorReset}")
                endforeach()
                set(_as_section_fail "TRUE")
           endif()
       endif()

    else()
        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake" "${_as_curr_section}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/sections/${_as_curr_section}.cmake")
        cpp_get_global(_as_exceptions "${_as_original_unit}_${_as_curr_section}_EXCEPTIONS")

        if(NOT "${_as_exceptions}" STREQUAL "")
            foreach(_as_exc IN LISTS _as_exceptions)
                message("${CT_BoldRed}Section named \"${_as_friendly_name}\" raised exception:")
                message("${_as_exc}${CT_ColorReset}")
            endforeach()
            set(_as_section_fail "TRUE")
        endif()
    endif()
    if(_as_section_fail)
        _ct_print_fail("${_as_friendly_name}" "${_as_new_section_depth}" "${_as_print_length}")
         cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE") #At least one test failed, so we will inform the caller that not all tests passed.
         ct_exit()
    else()
        _ct_print_pass("${_as_friendly_name}" "${_as_new_section_depth}" "${_as_print_length}")
    endif()


    # Get whether this section has subsections, only run again if subsections detected
    cpp_get_global(_as_has_subsections "CMAKETEST_TEST_${_as_original_unit}_${_as_curr_section}_SECTIONS")
    if((NOT _as_has_subsections STREQUAL "") AND ((NOT _as_expect_fail AND NOT _as_exec_expectfail) OR (_as_exec_expectfail))) #If in main interpreter and not expecting to fail OR in subprocess
        ct_exec_subsections()

    endif()

    cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_as_original_unit}")
    cpp_set_global("CMAKETEST_SECTION_DEPTH" "${_as_old_section_depth}")
    #cpp_set_global("CMAKETEST_TEST_${_as_curr_exec_unit}_EXECUTE_SECTIONS" FALSE) #Get whether we should execute section now

endfunction()
