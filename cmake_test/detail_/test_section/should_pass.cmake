include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)

#[[[ Returns whether the current test should pass or not.
#
# An important part of unit testing is ensuring that code fails when it is
# supposed to. For this reason the TestSection class has an internal attribute
# which keeps track of whether or not the test should fail. This function can
# be used to retrieve whether the current section should pass. The current
# section should pass if its parent section (assuming it exists) should also
# pass. If any section in the hierarchy should fail all subsections should fail
# as well (the parent section, which should fail, will be run before the
# subsection so the subsection will not even run).
#
# :param _tssp_handle: A TestSection instance
# :type _tssp_handle: TestSection
# :param _tssp_result: An identifier to hold whether the test should fail.
# :type _tssp_result: Identifier
# :returns: ``TRUE`` or ``FALSE`` depending on whether or not the test should
#           fail. The value is accessible to the caller via
#           ``${${_tssp_result}}``.
#]]
function(_ct_test_section_should_pass _tssp_handle _tssp_result)
    _ct_is_handle(_tssp_handle)
    _ct_nonempty_string(_tssp_result)

    # We pass if our parent passes and we're set to pass
    _ct_get_prop( ${_tssp_handle} ${_tssp_result} "should_pass")
    _ct_get_prop(${_tssp_handle} _tssp_parent "parent_section")
    if(NOT "${_tssp_parent}" STREQUAL "0")
        _ct_test_section_should_pass(${_tssp_parent} _tssp_parent_pass)
        if(NOT _tssp_parent_pass)
            set(${_tssp_result} FALSE)
        endif()
    endif()

    _ct_return(${_tssp_result})
endfunction()
