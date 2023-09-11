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

********************
Sections (Sub-Tests)
********************

Sections can be thought of as sub-tests
of a larger test or section. When a test
or section executes, all of its subsections
are also executed. An example is shown below:

.. literalinclude:: ../../../tests/cmake_test/basic_section.cmake
   :language: cmake


A subsection is defined with the :code:`ct_add_section()`
function followed by a function or macro definition
just like for tests. The section is defined *within*
the function or macro of an outer test or section.
Attempting to define a section outside of a containing
test will result in an error. Sections can be nested
with no inherent limit, but it is recommended to keep
nesting to a maximum of 2 or 3 levels.

A section is generally useful for logically grouping tests
underneath a common umbrella testcase along with their
common setup code.
