include_guard()
include(detail_/add_assert)

#MACRO
#
# Adds an assertion to a test section requiring that one or more strings appear
# in the output
#
macro(ct_assert_prints)
    foreach(_ap_input ${ARGN})
        _ct_add_assert("prints" "${_ap_input}")
    endforeach()
endmacro()
