********************
Sections (Sub-Tests)
********************

Sections can be thought of as sub-tests
of a larger test or section. When a test
or section executes, all of its subsections
are also executed. An example is shown below:

.. literalinclude:: ../../../tests/basic_section.cmake
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
