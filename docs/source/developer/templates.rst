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

.. _Bootstrap Templates:

###################
Bootstrap Templates
###################

CMakeTest tests cannot be executed directly
by CTest but instead require a bootstrap file to setup
the CMakeTest runtime. These bootstrap files are configured
at build time. The template these files are configured from is
``cmake_test/templates/lists.txt``. The file is listed below for
convenience.

.. literalinclude:: ../../../cmake_test/templates/lists.txt
   :language: cmake


The variables that are inserted into the template are as follows:

- :code:`_ct_min_cmake_version`: The minimum version of CMake required
  by CMakeTest. This variable is generally set by CMakeTest's
  ``CMakeLists.txt``
- :code:`_ad_test_file`: The file that contains the tests that
  this template bootstraps. This variable is generally set by
  :obj:`~cmake_test/add_dir.ct_add_dir`.
- :code:`CMAKETEST_USE_COLORS`: The option for whether to use colors
  that is propagated to the test. This variable is an option initially
  set by the :mod:`cmake_test/colors` module but can be changed at configure
  time by the user.
- :code:`CMAKEPP_LANG_DEBUG_MODE`: The option for whether CMakePPLang
  should run in debug mode. This option is treated specially because
  CMakeTest uses CMakePPLang internally, and enabling debug mode while
  running tests significantly impacts performance.
- :code:`CT_PRINT_LENGTH`: The variable for the print length
  of pass/fail lines when not overridden by the test. This variable
  is only set if the user overrides the default of 80 via the
  :obj:`~cmake_test/set_print_length.ct_set_print_length` function
  or if the :code:`PRINT_LENGTH` option is passed to
  :obj:`~cmake_test/add_test.ct_add_test` or
  :obj:`~cmake_test/add_section.ct_add_section` functions.
- :code:`CMAKE_MODULE_PATH`: This is the same module path list
  as used in normal CMake code, it is propagated down to prevent
  any module not found errors.


CMakeTest uses a second bootstrap file specifically
for executing :code:`EXPECTFAIL` tests in a subprocess. These files
are configured at test time from the ``cmake_test/templates/expectfail.txt``
template. The file is listed below for convenience.

.. literalinclude:: ../../../cmake_test/templates/expectfail.txt
   :language: cmake


The variables that are inserted into the template are as follows:

- :code:`_ct_min_cmake_version`: The minimum version of CMake required
  by CMakeTest. This variable is generally set by CMakeTest's
  ``CMakeLists.txt``.
- :code:`ct_debug_mode`: Whether CMakeTest itself should be debugged.
  This variable is stored in a CMakePP global called ``CT_DEBUG_MODE`,
  and is by default set to the value of ``CMAKEPP_LANG_DEBUG_MODE``
  upon inclusion of :obj:`cmake_test/cmake_test` at configure time.
- :code:`CMAKETEST_USE_COLORS`: The option for whether to use colors
  that is propagated to the test. This variable is an option initially
  set by the :mod:`cmake_test/colors` module but can be changed at configure
  time by the user.
- :code:`CT_PRINT_LENGTH`: The variable for the print length
  of pass/fail lines when not overridden by the test. This variable
  is only set if the user overrides the default of 80 via the
  :obj:`~cmake_test/set_print_length.ct_set_print_length` function
  or if the :code:`PRINT_LENGTH` option is passed to
  :obj:`~cmake_test/add_test.ct_add_test` or
  :obj:`~cmake_test/add_section.ct_add_section` functions.
- :code:`CMAKE_MODULE_PATH`: This is the same module path list
  as used in normal CMake code, it is propagated down to prevent
  any module not found errors.
- :code:`_es_section_file`: The containing file of the section.
- :code:`_es_section_id_defines`: A string containing CMake code that
  sets variables for test and section names to their current IDs. This
  determines which tests and sections are executed, as only units with a defined
  ID are executed when :code:`CT_EXEC_EXPECTFAIL` is true.