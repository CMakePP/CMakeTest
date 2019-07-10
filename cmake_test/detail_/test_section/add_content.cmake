include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/utilities/input_check)

## @memberof TestSection
#  @public
#  @fn _ct_test_section_add_content(handle, content)
#  @brief Adds additional CMake code to the current test's section.
#
#  This function will add an additional line of CMake code to the current test
#  section stored in the TestSection object.
#
#  @param[in] handle The handle to the TargetState object
#  @param[in] content The contents to append to the current test.
function(_ct_test_section_add_content _tsac_handle _tsac_content)
    _ct_is_handle(_tsac_handle)
    # Content can be empty

    cmake_policy(SET CMP0007 NEW) #No skipping empty elements

    # Get the list of existing content
    _ct_get_prop( ${_tsac_handle} _tsac_test_content "content")

    # Commit the new list of content
    _ct_add_prop(
       "${_tsac_handle}"
       "content"
       "${_tsac_test_content}\n${_tsac_content}"
    )
endfunction()

