include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/utilities/input_check)

#[[[ Adds additional CMake code to the current test's section.
#
# This function will add an additional line of CMake code to the current test
# section stored in the TestSection object. The line provided to this function
# will be printed verbatim to the output.
#
# :param _tsac_handle: The instance storing the contents of the unit test.
# :type _tsac_handle: TargetState
# :param _tsac_content: An identifier containing the contents to append.
# :type _tsac_content: str
#
#]]
function(_ct_test_section_add_content _tsac_handle _tsac_content)
    _ct_is_handle(_tsac_handle)
    _ct_nonempty_string(_tsac_content)

    cmake_policy(SET CMP0007 NEW) #No skipping empty elements

    # Get the list of existing content
    _ct_get_prop( ${_tsac_handle} _tsac_test_content "content")

    # If we don't have content, we do now...
    if("${_tsac_test_content}" STREQUAL "")
        _ct_add_prop(${_tsac_handle} "content" "${${_tsac_content}}")
    else() # Append to existing content
        _ct_add_prop(
            ${_tsac_handle}
            "content"
            "${_tsac_test_content}\n${${_tsac_content}}"
        )
    endif()
endfunction()

