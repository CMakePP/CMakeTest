include_guard()

## @fn _ct_assert_list(list)
#  @brief Returns (as a list) all of the asserts known to CMakeTest
#
#  This function encapsulates the logic required to retrieve a list of all
#  asserts known to CMakeTest. This is useful for looping over the assertions
#  and avoids us having to update that list in multiple places.
#
# @param[out] list An identifier to hold the list of known exceptions.
function(_ct_assert_list _al_list)
    set(${_al_list}
         "ct_assert_defined"
         "ct_assert_equal"
         "ct_assert_not_defined"
         "ct_assert_not_equal"
         "ct_assert_prints"
    )
endfunction ()
