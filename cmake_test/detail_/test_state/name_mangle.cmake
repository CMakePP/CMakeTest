include_guard()
include(cmake_test/detail_/utilities)

## @memberof TestState
#  @private
#  @fn _ct_name_mangle(mangled_name, target, attribute)
#  @brief Handles name mangling for the TestState class
#
# This function wraps the details of how we mangle our target's attributes.
# Ultimately when we want to create or access our target's attributes we
# rely on this function to mangle the name for us. This function is not part of
# the public API of the test_state class.
#
# @param[out] mangled_name Variable name to assign the mangled name to.
# @param[in] target The handle to the TargetState object
# @param[in] attribute The name of the attribute we want a mangled name for.
function(_ct_name_mangle _nm_mangled_name _nm_target _nm_attribute)
    set(${_nm_mangled_name} "${_nm_target}_${_nm_attribute}")
    _ct_return(${_nm_mangled_name})
endfunction()
