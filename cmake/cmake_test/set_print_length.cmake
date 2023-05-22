#[[[
# Wrapper macro to set CT_PRINT_LENGTH variable in current scope.
# This length can be overriden by setting `PRINT_LENGTH`
# in `ct_add_test()` or `ct_add_section()`
#
# Priority for print length is as follows (first most important):
#  1. Current execution unit's PRINT_LENGTH option
#  2. Parent's PRINT_LENGTH option
#  3. Length set by ct_set_print_length()
#  4. Built-in default of 80.
#
# :param _spl_length: Length for pass/fail print lines.
# :type _spl_length: int
#]]
macro(ct_set_print_length _spl_length)
   set(CT_PRINT_LENGTH "${_spl_length}")
endmacro()
