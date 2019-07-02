include_guard()
include(cmake_test/detail_/test_state/add_prop)
include(cmake_test/detail_/test_state/get_prop)
include(cmake_test/detail_/utilities)

## @memberof TestState
#  @public
#  @fn ADD_CONTENT(handle, content)
#  @brief Adds additional CMake code to the current test's section.
#
#  This function will add an additional line of CMake code to the current test
#  section stored in the TestState object. The actual content is stored in a
#  list, where element i is the content added at a depth of i.
#
#  @note The content at depth i is concatenated using end line characters so
#        there's no need to worry about nesting lists beyond what was previously
#        mentioned.
#
#  @param[in] handle The handle to the TargetState object
#  @param[in] content The contents to append to the current test.
function(_ct_test_state_add_content _tsac_handle _tsac_content)
    _ct_variable_is_set(_tsac_handle "Handle must be set and valid")
    # Content can be empty

    cmake_policy(SET CMP0007 NEW) #No skipping empty elements

    # Get the list of existing content
    _ct_get_prop(_tsac_test_content ${_tsac_handle} "test_content")
    list(LENGTH _tsac_test_content _tsac_length)

    # How we add content depends on whether we have content and whether the
    # current section's content is empty
    if("${_tsac_length}" GREATER "0") # Have content, append to list

        #Get the last element
        list(GET _tsac_test_content -1 _tsac_elem)

        # Dispatch on whether or not the last element has content
        if("${_tsac_elem}" STREQUAL "") # No content
            set(_tsac_test_content "${_tsac_test_content}${_tsac_content}")
        else() # Has content
            set(_tsac_test_content "${_tsac_test_content}\n${_tsac_content}")
        endif()

    else() # Don't have any content yet
        set(_tsac_test_content "${_tsac_content}")
    endif()

    # Commit the new list of content
    _ct_add_prop("${_tsac_handle}" "test_content" "${_tsac_test_content}")
endfunction()

