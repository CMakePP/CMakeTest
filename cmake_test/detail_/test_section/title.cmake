include_guard()
include(cmake_test/detail_/test_section/private)
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)

#[[[ Returns the title of the current section.
#
# This function will return the title of the section modled by the provided
# TestSection instance.
#
# :param _tsgt_handle: The handle to the section
# :type _tsgt_handle: TestSection
# :param _tsgt_title: The title of the current test case.
# :type _tsgt_title: Identifier
# :returns: A string indicating the title of the test case accesible to the
#           caller via ``_tsgt_title``.
#]]
function(_ct_test_section_get_title _tsgt_handle _tsgt_title)
    _ct_is_handle(_tsgt_handle)
    _ct_nonempty_string(_tsgt_title)

    _ct_get_prop("${_tsgt_handle}" ${_tsgt_title} "title")
    _ct_return(${_tsgt_title})
endfunction()
