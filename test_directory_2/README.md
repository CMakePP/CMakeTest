# Secondary Test Directory
This test directory is for the sole purpose of testing for
any conflicts between tests of the same name but placed in different directories.
There is a single test in this directory, named `test_same_name_diff_directory.cmake`,
that contains an empty test definition. This test is copied in the main
`tests/` directory with the same name. This secondary directory is then added
via `ct_add_dir()` in the same way the `tests/` directory is added.
In doing so, we are testing the `ct_add_dir()` function to ensure
it can disambiguate between tests with the same name.

See Issue #41 on Github for full context of the bug that required such testing.