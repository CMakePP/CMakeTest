include_guard()
include(cmake_test/detail_/test_section/test_section)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/lc_find)

#[[[ Parses an assert found in a unit test.
#
# This function is responsible for dispatching among the various types of
# assertions. For the most part the assertions simply need to be dumped into
# the contents of the unit test; however, there are a few assertions such as
# "ct_assert_prints, which require different handeling. The logic for these
# special asserts is encapsulated within this function. At the moment the
# special asserts are:
#
# - ``ct_assert_prints``
# - ``ct_assert_fails_as``
#
# :param _pa_handle: The unit test instance we are building up.
# :type _pa_handle: TargetObject
# :param _pa_line: The line in the unit test we are parsing.
# :type _pa_line: str
#]]
function(_ct_parse_assert _pa_handle _pa_line)
    _ct_is_handle(_pa_handle)
    _ct_nonempty_string(_pa_line)

    # See if this is one of the special assertions
    _ct_lc_find(_pa_is_print "ct_assert_prints" "${${_pa_line}}")
    _ct_lc_find(_pa_is_fail  "ct_assert_fails_as" "${${_pa_line}}")

    if(_pa_is_print)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pa_match "${${_pa_line}}")
        _ct_test_section(MUST_PRINT ${_pa_handle} "${CMAKE_MATCH_1}")
    elseif(_pa_is_fail)
        string(REGEX MATCH "\\(\\s*\"(.*)\"\\s*\\)" _pa_match "${${_pa_line}}")
        _ct_test_section(MUST_PRINT ${_pa_handle} ${CMAKE_MATCH_1})
        _ct_test_section(SHOULD_FAIL ${_pa_handle})
    else() # dispatch for all other assertions
        _ct_test_section(ADD_CONTENT ${_pa_handle} "${_pa_line}")
    endif()
endfunction()
