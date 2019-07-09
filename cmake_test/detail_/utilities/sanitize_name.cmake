include_guard()
include(cmake_test/detail_/utilities/return)

## @fn _ct_sanitize_name(new_name, old_name)
#  @brief Makes the provided name more filesystem friendly
#
#  CMakeTest will need to turn test names into file names in a few places. This
#  requires the test name to be filesystem friendly. More specifically we:
#
#  - Make the string lowercase
#  - Replace spaces with underscores
#  - Replace colons with hyphens
#
#  @param[out] new_name An identifier to which the new name will be assigned
#  @param[in]  old_name The string we are
function(_ct_sanitize_name _sn_new_name _sn_old_name)
    string(TOLOWER "${_sn_old_name}" _sn_old_name)
    string(REPLACE " " "_" ${_sn_new_name} "${_sn_old_name}")
    string(REPLACE ":" "-" ${_sn_new_name} "${${_sn_new_name}}")
    _ct_return(${_sn_new_name})
endfunction()
