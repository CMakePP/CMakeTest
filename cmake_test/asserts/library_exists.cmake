include_guard()

#[[[ Asserts that a library exists.
#
# Asserts that the target exists and is a library.
#
# :param _ale_name: The name of the library
# :type _afe_path: String
#]]
function(ct_assert_library_exists _ale_name)
    # Check that the target exists and it is a library
    if(TARGET "${_ale_name}")
        get_target_property(_ale_target_type "${_ale_name}" TYPE)
        if (NOT (_ale_target_type STREQUAL "STATIC_LIBRARY" OR
                _ale_target_type STREQUAL "MODULE_LIBRARY" OR
                _ale_target_type STREQUAL "SHARED_LIBRARY"))
            message(FATAL_ERROR "Target ${_ale_name} is not a library.")
        endif()
    else()
        message(FATAL_ERROR "Library target ${_ale_name} does not exist.")
    endif()
endfunction()

#[[[ Asserts that a library does not exist.
#
# Asserts that the target does not exist or is not a library.
#
# :param _aldne_name: The name of the library
# :type _aldne_name: String
#]]
function(ct_assert_library_does_not_exist _aldne_name)
    # Check that the target does not exist or is not a library
    if(TARGET _ale_name)
        get_target_property(_aldne_target_type "${_aldne_name}" TYPE)
        if (_ale_target_type STREQUAL "STATIC_LIBRARY" OR
            _ale_target_type STREQUAL "MODULE_LIBRARY" OR
            _ale_target_type STREQUAL "SHARED_LIBRARY")
            message(FATAL_ERROR "Library target ${_ale_name} does exist.")
        endif()
    endif()
endfunction()
