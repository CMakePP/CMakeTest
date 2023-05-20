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

asserts
=======

This directory contains assertions that users may want to use in their unit
tests. All assertions come in two flavors an affirmative assert and a negative
assert. For example:

```
ct_assert_defined(AN_IDENTIFIER)       # Fails if AN_IDENTIFIER is not defined
ct_assert_not_defined(AN_IDENTIFIER)   # Fails if AN_IDENTIFIER is defined
```

Assertion Summaries:

- `asserts.cmake` : Convenience header for including all assertions
- `defined.cmake` : Determines if a variable is defined
- `equal.cmake` : Assertions for comparing values
- `list.cmake` : Determines if an identifier contains a list
- `string.cmake` : Asserts that an identifier contains a string
- `prints.cmake` : Asserts that a string was printed using `message()`
