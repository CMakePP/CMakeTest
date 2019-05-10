include_guard()

function(_pt_debug_print)
    if(_pt_debug_parse)
        message("${ARGN}")
    endif()
endfunction()

function(_ct_parse_test _pt_sections _pt_contents _pt_asserts _pt_file)

    set(_pt_in_test FALSE)
    set(_pt_debug_parse TRUE)
    foreach(_pt_line ${_pt_file}) #Loop over lines
        _pt_debug_print("Line: ${_pt_line}")
        if(_pt_in_test) #Dispatch for parsing the test
            string(FIND "${_pt_line}" "ct_add_section" _pt_is_add_sec)
            string(FIND "${_pt_line}" "ct_end_section" _pt_is_end_sec)
            string(FIND "${_pt_line}" "ct_end_test" _pt_is_end_test)
            string(FIND "${_pt_line}" "ct_assert" _pt_is_assert)

            if(NOT "${_pt_is_add_sec}" STREQUAL "-1")
                _pt_debug_print("Result: Is new_section")
            elseif(NOT "${_pt_is_end_sec}" STREQUAL "-1")
                _pt_debug_print("Result: Is end_section")
            elseif(NOT "${_pt_is_end_test}" STREQUAL "-1")
                _pt_debug_print("Result: Is end_test")
                set(_pt_in_test FALSE)
            elseif(NOT "${_pt_is_assert}" STREQUAL "-1")
                _pt_debug_print("Result: Is assert")
            else()
                _pt_debug_print("Resutl: Is code")
                list(APPEND ${_pt_contents} "${_pt_line}")
            endif()
        else() #Dispatch for parsing other lines
            string(FIND "${_pt_line}" "ct_add_test" _pt_is_add_test)
            if("${_pt_is_add_test}" STREQUAL "-1") #Not add test
                _pt_debug_print("Result: Not part of this test.")
                continue()
            endif()
            string(FIND "${_pt_line}" "${_pt_test_name}" _pt_is_this_test)
            if("${_pt_is_this_test}" STREQUAL "-1") #Not this test
                message(FATAL_ERROR "Can not nest add_test commands.")
            endif()
            set(_pt_in_test TRUE)
            _pt_debug_print("Result: Is start of this test")
        endif()
    endforeach()

    set(${_pt_sections} "${${_pt_sections}}" PARENT_SCOPE)
    set(${_pt_contents} "${${_pt_contents}}" PARENT_SCOPE)
    set(${_pt_asserts}  "${${_pt_asserts}}"  PARENT_SCOPE)
endfunction()
