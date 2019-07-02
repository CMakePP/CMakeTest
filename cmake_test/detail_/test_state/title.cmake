include_guard()
include(cmake_test/detail_/utilities)

## @memberof TestState
#  @public
#  @fn TITLE(handle, title)
#  @brief Returns the title of the current test's section.
#
#  This function will return a string of the form:
#
#  <test name> : <section> : <subsection> : <sub-subsection> : ...
#
#  Where `<test_name>` is the name of the unit test specified in the `add_test`
#  command appended with the section titles encountered so far.
#
#  @param[in] handle The handle to the TargetState object
#  @param[out] title The title of the current test case.
function(_ct_test_state_get_title _tsgt_handle _tsgt_title)
    _ct_get_prop(_tsgt_titles "${_tsgt_handle}" "section_titles")
    list(LENGTH _tsgt_titles _tsgt_length)
    set(_tsgt_counter 0)
    set(${_tsgt_title} "")
    while("${_tsgt_counter}" LESS "${_tsgt_length}")
        list(GET _tsgt_titles ${_tsgt_counter} _tsgt_part)

        # Only print colon for subsections
        if("${_tsgt_counter}" GREATER "0")
            set(${_tsgt_title} "${${_tsgt_title}} : ")
        endif()

        set(${_tsgt_title} "${${_tsgt_title}}${_tsgt_part}")
        math(EXPR _tsgt_counter "${_tsgt_counter} + 1")
    endwhile()
    _ct_return(${_tsgt_title})
endfunction()
