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

utilities
=========

This directory contains odds and ends that are used throughout the CMakeTest
module, but haven't been classified as belonging to other categories.

Below are quick descriptions of what all is in this directory:

- `input_check` : asserts for type-checking inputs to a function
- `lc_find` : searches a string for a substring in a type-insensitive manner
- `print_result` : wraps the boilerplate associated with printing pass/fail
- `repeat_string` : Creates a string of a specified length by repeating a string
- `return` : Syntactic sugar for adding a "return" statement to CMake
- `sanitize_name` : wraps the process of making a string filesystem-friendly
- `utilities` : convenience header for including all functions in this directory
