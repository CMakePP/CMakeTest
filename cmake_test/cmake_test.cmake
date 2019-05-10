#"Convenience" header for using the CMakeTest module
include_guard()
include(cmake_test/add_section)
include(cmake_test/add_test)
#include(cmake_test/assert_prints)
include(cmake_test/end_test)
include(cmake_test/detail_/run_unit_test)

#These are implementation details
set(_ct_file_parsed FALSE)
set(_ct_test_names)
set(_ct_sections_per_test) #NTests long array of number of sections per test
set(_ct_sectons_offset) #Where in the next array test i's sections start
set(_ct_sections) #All the sections
set(_ct_asserts_per_section) #Number of asserts per test
set(_ct_asserts_offset) #Where section i's asserts start
set(_ct_asserts) #All the asserts
