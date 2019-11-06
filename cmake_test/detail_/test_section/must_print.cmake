include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/test_section/private)

#[[[ Adds to the current section, a check for the provided message
#
# The user may request that we assert that a particular test prints one or
# messages. This is done after the test runs by parsing the output. This
# function is responsible for adding a message to the list of messages that
# must appear in the output.
#
# :param _tsmp_handle: The TestSection to add the assert to.
# :type _tsmp_handle: TestSection
# :param _tsmp_message: The message that must appear in the output of the
#                       current test. Can not be empty.
# :type _tsmp_message: str
#]]
function(_ct_test_section_must_print _tsmp_handle _tsmp_message)
    _ct_is_handle(_tsmp_handle)
    _ct_nonempty(_tsmp_message)

    # Add the message
    _ct_get_prop(${_tsmp_handle} _tsmp_asserts  "print_assert")
    string(REGEX REPLACE ";" "\\\\;" _tsmp_message "${_tsmp_message}")
    list(APPEND _tsmp_asserts "${_tsmp_message}")
    _ct_add_prop(${_tsmp_handle} "print_assert" "${_tsmp_asserts}")
endfunction()
