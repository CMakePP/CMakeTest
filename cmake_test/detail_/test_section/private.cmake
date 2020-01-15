include_guard()
include(cmake_test/detail_/utilities/input_check)
include(cmake_test/detail_/utilities/return)

#[[[ Handles name mangling for the TestSection class
#
# This function wraps the details of how we mangle our target's attributes.
# Ultimately when we want to create or access our target's attributes we
# rely on this function to mangle the name for us.
#
# :param _nm_target: The handle to the TargetState object
# :type _nm_target: TargetState
# :param _nm_mangled_name: Identifier to assign the mangled name to.
# :type _nm_mangled_name: Identifier
# :param _nm_attribute: The name of the attribute we want a mangled name for.
# :type _nm_attribute: str
# :returns: The mangled name of the attribute via ``${${_nm_mangled_name}}``.
#]]
function(_ct_name_mangle _nm_target _nm_mangled_name _nm_attribute)
    _ct_is_handle(_nm_target)
    _ct_nonempty_string(_nm_mangled_name)
    _ct_nonempty_string(_nm_attribute)

    set(${_nm_mangled_name} "${_nm_target}_${_nm_attribute}")
    _ct_return(${_nm_mangled_name})
endfunction()

#[[[ Adds a property to the the TestSection instance
#
# This function wraps the process of adding a property to a TestSection
# instance. If the property already exists its value will be overridden. Hence
# this  function is used for the initial creation as well as updating the value.
#
# :param _ap_handle: The handle of the TestSection instance we are adding the
#                    attribute to.
# :type _ap_handle: TestSection
# :param _ap_name: The name of the attribute we are adding.
# :type _ap_name: str
# :param _ap_value: The value to set the attribute to.
#]]
function(_ct_add_prop _ap_target _ap_name _ap_default_value)
    _ct_is_handle(_ap_target)
    _ct_nonempty_string(_ap_name)
    _ct_name_mangle("${_ap_target}" _ap_handle "${_ap_name}")

    # CMake returns an empty string if we get the property name wrong. Here we
    # use a mangled null value so we know whether it was set to "" by the user
    # or if we got the property name wrong
    if("${_ap_default_value}" STREQUAL "")
        set(_ap_default_value "${_ap_target}_NULL")
    endif()

    set_property(GLOBAL PROPERTY "${_ap_handle}" "${_ap_default_value}")
endfunction()

#[[[ Retrieves a property from the TestSection instance
#
# This function wraps the process of retrieving a property's value from a
# TestSection instance.
#
# :param _gp_handle: The handle of the TestSection instance we are retrieving
#                    the attribute from.
# :type _gp_handle: TestSection
# :param _gp_value: An identifier to hold the value of the requested attribute.
# :type _gp_value: Identifier
# :param _gp_property: The name of the attribute we want the value of.
# :type _gp_property: str
# :returns: The value of the requested attribute via ``${${_gp_value}}``.
#]]
function(_ct_get_prop _gp_target _gp_value _gp_name)
    _ct_is_handle(_gp_target)
    _ct_nonempty_string(_gp_value)
    _ct_nonempty_string(_gp_name)

    _ct_name_mangle("${_gp_target}" _gp_handle "${_gp_name}")
    get_property(${_gp_value} GLOBAL PROPERTY "${_gp_handle}")

    # See if the attribute exists and handle our internal null state
    if("${${_gp_value}}" STREQUAL "")
        message(FATAL_ERROR "TestSection has no attribute ${_gp_name}")
    elseif("${${_gp_value}}" STREQUAL "${_gp_target}_NULL")
        set(${_gp_value} "")
    endif()

    _ct_return(${_gp_value})
endfunction()
