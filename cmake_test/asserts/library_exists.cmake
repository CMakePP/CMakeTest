include_guard()

#[[[ Asserts that a library exists.
#
# Asserts that the target exists and is a library.
#
# :param _ale_name: The name of the library
# :type _afe_path: string
#]]
function(ct_assert_library_target_exists _ale_name)
    # Check that the target exists and it is a library
    ct_library_target_exists(_ale_result "${_ale_name}")
    if(_ale_result EQUAL 1)
        message(FATAL_ERROR "Target ${_ale_name} is not a library.")
    elseif(_ale_result EQUAL 2)
        message(FATAL_ERROR "Library target ${_ale_name} does not exist.")
    endif()
endfunction()

#[[[ Asserts that a library does not exist.
#
# Asserts that the target does not exist or is not a library.
#
# :param _aldne_name: The name of the library
# :type _aldne_name: string
#]]
function(ct_assert_library_does_not_exist _aldne_name)
    # Check that the target does not exist or is not a library
    ct_library_target_exists(_aldne_result "${_aldne_name}")
    if(_aldne_result EQUAL 0)
        message(FATAL_ERROR "Library target ${_aldne_name} does exist.")
    endif()
endfunction()

#[[[ Determines if a target exists and if it is a library.
#
# This function checks whether a target exists and then checks whether that
# target is of type ``STATIC_LIBRARY``, ``MODULE_LIBRARY``, or
# ``SHARED_LIBRARY`` and then returns an integer indicating what it found.
#
# :param _lte_result: Name to use for the variable which will hold the result.
# :type _lte_result: int
# :param _lte_name: The target name to check.
# :type _lte_name: string
# :returns: ``_lte_result`` will be set to ``0`` if the target is a library,
            ``1`` if the target is not a library, and ``2`` if target does not
            exist.
# :rtype: int
#]]
function(ct_library_target_exists _lte_result _lte_name)
    # Return 0 if target is library, 1 if it is not, 2 if it does not exist
    if(TARGET "${_lte_name}")
        get_target_property(_lte_target_type "${_lte_name}" TYPE)
        if (_lte_target_type STREQUAL "STATIC_LIBRARY" OR
            _lte_target_type STREQUAL "MODULE_LIBRARY" OR
            _lte_target_type STREQUAL "SHARED_LIBRARY")
            set("${_lte_result}" 0 PARENT_SCOPE)
        else()
            set("${_lte_result}" 1 PARENT_SCOPE)
        endif()
    else()
        set("${_lte_result}" 2 PARENT_SCOPE)
    endif()
endfunction()
