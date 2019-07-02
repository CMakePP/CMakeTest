include_guard()
include(cmake_test/detail_/utilities)
include(cmake_test/detail_/test_state/name_mangle)

## @memberof TestState
#  @private
#  @fn _ct_add_prop(handle, name, value)
#  @brief Adds a property to the the TestState instance
#
# This function wraps the process of adding a property to a TestState instance.
# If the property already exists its value will be overridden. Hence this
# function is used for the initial creation as well as updating the value.
#
# @param[in] handle The handle of the TestState instance we are adding the
#                   attribute to.
# @param[in] name The name of the attribute we are adding.
# @param[in] value The value to set the attribute to.
function(_ct_add_prop _ap_target _ap_name _ap_default_value)
    _ct_variable_is_set(_ap_target "Must provide a handle")
    _ct_variable_is_set(_ap_name "Must provide a name")

    _ct_name_mangle(_ap_handle "${_ap_target}" "${_ap_name}")
    set_property(GLOBAL PROPERTY "${_ap_handle}" "${_ap_default_value}")
endfunction()
