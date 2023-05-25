<!--
  ~ Copyright 2023 CMakePP
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

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