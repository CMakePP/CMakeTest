include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)
include(cmake_test/detail_/test_section/name_mangle)

## @memberof TestSection
#  @private
#  @fn _ct_get_prop(value, handle, property)
#  @brief Retrieves a property from the TestSection instance
#
# This function wraps the process of retrieving a property's value from a
# TestSection instance. Because of how CMake works, there's no way to determine
# if the value we are obtaining is currently empty or if we requested a bogus
# property without additional work. At the moment this function does not assert
# that the property actually exists
#
# @param[out] value The value of the requested attribute..
# @param[in] handle The handle of the TestSection instance we are retrieving the
#                   attribute from.
# @param[in] property The name of the attribute we want the value of.
function(_ct_get_prop _gp_value _gp_target _gp_name)
    _ct_nonempty_string(_gp_value)
    _ct_is_handle(_gp_target)
    _ct_nonempty_string(_gp_name)

    _ct_name_mangle(_gp_handle "${_gp_target}" "${_gp_name}")
    get_property(${_gp_value} GLOBAL PROPERTY "${_gp_handle}")
    _ct_return(${_gp_value})
endfunction()
