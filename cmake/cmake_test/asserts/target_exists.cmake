include_guard()

#[[[ Assert that a target exists.
#
# :param _ate_name: The name of the target
# :type _ate_name: String
#]]
function(ct_assert_target_exists _ate_name)
    # Check if the target exists, if not throw an error
    if(NOT TARGET "${_ate_name}")
        message(FATAL_ERROR "Target ${_ate_name} does not exist.")
    endif()
endfunction()

#[[[ Assert that a target does not exist.
#
# :param _ate_name: The name of the target
# :type _ate_name: String
#]]
function(ct_assert_target_does_not_exist _atdne_name)
    # Check if the target exists, if it does, throw an error
    if(TARGET "${_atdne_name}")
        message(FATAL_ERROR "Target ${_atdne_name} does exist.")
    endif()
endfunction()
