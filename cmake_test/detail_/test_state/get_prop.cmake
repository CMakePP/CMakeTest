include_guard()
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_state/name_mangle)

## @memberof TestState
#  @private
#  @fn _ct_get_prop(String, TestState, String)
#  @brief Retrieves a property from the TestState instance
#
# This function wraps the process of retrieving a property's value from a
# TestState instance. Because of CMake works there's no way to determine if the
# value we are obtaining is currently empty or not an existing property. Hence
# this function does no error checking in that regard.
#
# @param[out] value The value of the attribute..
# @param[in] target The handle of the TestState instance we are retrieving the
#                   attribute from.
# @param[in] name The name of the attribute we want the value of.
function(_ct_get_prop _gp_value _gp_target _gp_name)
    _ct_variable_is_set(_gp_value "Must provide an output variable")
    _ct_variable_is_set(_gp_target "Must provide handle")
    _ct_variable_is_set(_gp_name "Must provide property name")

    _ct_name_mangle(_gp_handle "${_gp_target}" "${_gp_name}")
    get_property(${_gp_value} GLOBAL PROPERTY "${_gp_handle}")
    _ct_return(${_gp_value})
endfunction()
