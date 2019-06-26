include(cmake_test/detail_/test_state)

_ct_test_state_ctor(test_state "TestState Class")

_ct_test_state_print(${test_state})
message("======================================================================")
_ct_test_state_add_content(${test_state} "Hello World")

_ct_test_state_print(${test_state})
message("======================================================================")
