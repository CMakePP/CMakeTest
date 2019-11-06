include_guard()
include(cmake_test/detail_/utilities/return)

#[[[ Makes the provided name more filesystem friendly
#
# CMakeTest will need to turn test names into file names in a few places. This
# requires the test name to be filesystem friendly. More specifically we:
#
# - Make the string lowercase
# - Replace spaces with underscores
# - Replace colons with hyphens
#
# :param _sn_new_name: An identifier to which the new name will be assigned
# :type _sn_new_name: Identifier
# :param _sn_old_name: The string that we are sanitizing.
# :type _sn_old_name: str
# :returns: A string containing the sanitized name. The result is accessible to
#           the caller via ``_sn_new_name``.
#]]
function(_ct_sanitize_name _sn_new_name _sn_old_name)
    string(TOLOWER "${_sn_old_name}" _sn_old_name)
    string(REPLACE " " "_" ${_sn_new_name} "${_sn_old_name}")
    string(REPLACE ":" "-" ${_sn_new_name} "${${_sn_new_name}}")
    _ct_return(${_sn_new_name})
endfunction()
