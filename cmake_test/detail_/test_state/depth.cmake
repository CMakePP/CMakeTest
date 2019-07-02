include_guard()
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_state/get_prop)

## @memberof TestState
#  @public
#  @fn DEPTH(handle, depth)
#  @brief Determines the nesting of the current test section.
#
#  This function will determine how deeply nested the current test section is.
#  A depth of 0 indicates we are inside the original `ct_add_test` call. A depth
#  of 1 indicates we are inside the first `ct_add_section` call. A depth of 2
#  means we are inside an `ct_add_section` call within the first
#  `ct_add_section` call, etc.
#
#  @param[in] handle The handle to the TargetState object
#  @param[out] depth How deeply nested the current section is.
function(_ct_test_state_current_depth _tscd_handle _tscd_depth)
    _ct_variable_is_set(_tscd_handle "Must provide a handle.")
    _ct_variable_is_set(_tscd_depth  "Must provide a return name.")

    # Depth is the number of titles minus 1 (the zero-th title is the name of
    # the test)
    _ct_get_prop(_tscd_titles ${_tscd_handle} "section_titles")
    list(LENGTH _tscd_titles ${_tscd_depth})
    math(EXPR ${_tscd_depth} "${${_tscd_depth}} - 1")

    _ct_return(${_tscd_depth})
endfunction()
