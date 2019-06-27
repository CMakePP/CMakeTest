include(cmake_test/detail_/test_state)

test_state(CTOR state "TestState Class")
test_state(PRINT ${state})
message("======================================================================")
test_state(ADD_CONTENT ${state} "Hello World")
test_state(PRINT ${state})
message("======================================================================")
