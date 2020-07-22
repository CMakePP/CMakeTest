include_guard()

#[[[
# Execute all declared tests in a file. This function will be ran after ``include()``ing the test file.
# It will execute a subprocess for all declared tests that are expected to fail, but run all other tests in-process.
#
# .. seealso:: :func:`add_test.cmake.ct_add_test` for details on EXPECTFAIL.
#]]
function(ct_exec_tests)
    #[[
    #set(options EXPECTFAIL)
    #set(oneValueArgs NAME)
    #set(multiValueArgs "")
    #cmake_parse_arguments(CT_EXEC_TEST "${options}" "${oneValueArgs}"
    #                      "${multiValueArgs}" ${ARGN} )
    #]]



    message(STATUS "Executing tests")

    set(CMAKETEST_TESTS_DID_PASS "TRUE" PARENT_SCOPE) #Default to true and set to false once one does not pass

    # Add general exception handler that catches all exceptions
    cpp_catch(ALL_EXCEPTIONS)
    function("${ALL_EXCEPTIONS}" exce_type message)

        cpp_get_global(_ae_curr_exec "CT_CURRENT_EXECUTION_UNIT")
        #get_property(curr_exceptions GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS")

        #list(APPEND curr_exceptions "Type: ${exce_type}, Details: ${message}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTIONS" "${curr_exceptions}")
        #set_property(GLOBAL PROPERTY "${curr_exec}_EXCEPTION_DETAILS" "Type: ${exce_type}, Details: ${message}")

        cpp_append_global("${_ae_curr_exec}_EXCEPTIONS" "Type: ${exce_type}, Details: ${message}")
    endfunction()

    cpp_get_global(_et_tests "CMAKETEST_TESTS")

    foreach(_et_curr_test IN LISTS _et_tests)
        #Set the fully qualified identifier for this test, used later for exception tracking and section/subsection execution
        cpp_set_global("CT_CURRENT_EXECUTION_UNIT" "${_et_curr_test}")
        cpp_get_global(_et_friendly_name "CMAKETEST_TEST_${_et_curr_test}_FRIENDLY_NAME")
        cpp_get_global(_et_expect_fail "CMAKETEST_TEST_${_et_curr_test}_EXPECTFAIL")
        #message(STATUS "Running test named \"${friendly_name}\"")

        file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test}/${_et_curr_test}.cmake" "${_et_curr_test}()")
        include("${CMAKE_CURRENT_BINARY_DIR}/${_et_curr_test}/${_et_curr_test}.cmake")
        #ct_exec_sections()
        cpp_get_global(_et_exceptions "${_et_curr_test}_EXCEPTIONS")
        #get_property(ct_exception_details GLOBAL PROPERTY "${curr_test}_EXCEPTION_DETAILS")
        if(_et_expect_fail)
            if("${_et_exceptions}" STREQUAL "")
                message("${CT_BoldRed}Test named \"${_et_friendly_name}\" was expected to fail but did not throw any exceptions or errors.${CT_ColorReset}")
                set(CMAKETEST_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
                set(CMAKETEST_TEST_FAIL "TRUE")
            endif()
        else()
            if(NOT ("${_et_exceptions}" STREQUAL ""))
                #file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake" "${curr_test}()")
                #include("${CMAKE_CURRENT_BINARY_DIR}/${curr_test}/${curr_test}.cmake")
                #ct_exec_sections()
                foreach(_et_exc IN LISTS _et_exceptions)
                    message("${CT_BoldRed}Test named \"${_et_friendly_name}\" raised exception:")
                    message("${_et_exc}${CT_ColorReset}")
                endforeach()
                set(CMAKETEST_TESTS_DID_PASS "FALSE" PARENT_SCOPE) #At least one test failed, so we will inform the caller that not all tests passed.
                set(CMAKETEST_TEST_FAIL "TRUE")
            endif()
        endif()

        if(CMAKETEST_TEST_FAIL)
            _ct_print_fail("${_et_friendly_name}" 0)
        else()
            _ct_print_pass("${_et_friendly_name}" 0)
        endif()
        ct_exec_sections()
    endforeach()
endfunction()
