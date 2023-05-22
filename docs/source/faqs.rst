.. Copyright 2023 CMakePP
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

Frequently Asked Questions (FAQs)
=================================

1. Why does ``ct_assert_prints`` fail to find a string that is present?

   - Are you sure it's present in the output **EXACTLY** as your search string?
     For better or for worse, CMake's ``message`` command does some formatting
     on strings before printing them (*e.g*, inserts two spaces after a period).
     Furthermore, it can be a real pain to match printed strings with line
     breaks in them. It is highly recommended that you search for a key phrase
     rather than the entire print-out.

2. Why do my tests not run when I execute :code:`ctest`?

   - Ensure that you've built your tests with CMake and your
     ``CMakeLists.txt`` is calling :code:`ct_add_dir()` with
     the correct directory. When you build your tests you should
     see a message "Building tests".