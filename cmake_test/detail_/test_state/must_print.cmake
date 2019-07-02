include_guard()
include(cmake_test/detail_/test_state/depth)
include(cmake_test/detail_/test_state/add_prop)
include(cmake_test/detail_/test_state/get_prop)

## @memberof TestState
#  @public
#  @fn MUST_PRINT(handle, message)
#  @brief Adds to the current section, a check for the provided message
#
#  The user may request that we assert that a particular test prints one or
#  messages. This is done after the test runs by parsing the output. This
#  function is responsible for adding a message to the list of messages that
#  must appear in the output.
#
#  The actual list of messages is a list of lists such that element i of the
#  outer list is the list of messages that must appear in tests of depth i or
#  greater. To avoid issues with escaping the list characters, the internal list
#  is flattened out. As a result, in a separate list `passert_per_level` we
#  store the number of messages per depth.
#
# @param[in] handle A variable for the newly created TestState's handle.
# @param[in] message The message that must appear in the output of the current
#                    test.
function(_ct_test_state_must_print _tsmp_handle _tsmp_message)
    _ct_variable_is_set(_tsmp_handle "Must provide valid object handle")
    _ct_variable_is_set(_tsmp_message "Assert string can not be empty")

    # Add the message
    _ct_get_prop(_tsmp_asserts ${_tsmp_handle} "print_assert")
    list(APPEND _tsmp_asserts "${_tsmp_message}")
    _ct_add_prop(${_tsmp_handle} "print_assert" "${_tsmp_asserts}")

    # Update count
    _ct_get_prop(_tsmp_apl ${_tsmp_handle} "passert_per_level")
    _ct_test_state_current_depth(${_tsmp_handle} _tsmp_depth)
    list(GET _tsmp_apl ${_tsmp_depth} _tsmp_elem)
    math(EXPR _tsmp_elem "${_tsmp_elem} + 1")

    # Copy depth-1 list values over to new list
    set(_tsmp_temp "")
    foreach(_tsmp_i RANGE ${_tsmp_depth})
        if("${_tsmp_i}" STREQUAL "${_tsmp_depth}")
            break()
        endif()
        list(GET _tsmp_apl ${_tsmp_i} _tsmp_elem_i)
        list(APPEND _tsmp_temp "${_tsmp_elem_i}")
    endforeach()
    list(APPEND _tsmp_temp "${_tsmp_elem}")

    _ct_add_prop(${_tsmp_handle} "passert_per_level" "${_tsmp_temp}")
endfunction()
