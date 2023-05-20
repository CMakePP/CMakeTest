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

###############################
Architecture and Execution Flow
###############################

CMakeTest is built around the concept of an ``Execution Unit``.
A unit is an object representing a test or test section
and may contain other subunits that represent subsections.
An execution unit contains all of the information needed
to run the test including the containing file,
the test ID, and whether its :code:`EXPECTFAIL` option is set.
The object system is provided by ``CMakePP`` and the class
that represents execution units is
:obj:`~cmake_test/execution_unit.CTExecutionUnit`.

----------------
Execution Stages
----------------
CMakeTest runs in two stages: the configure stage and the test stage.
The test stage is executed by a :code:`ctest` command in the directory
that tests are built in.

===============
Configure Stage
===============
During the configure stage, CMakeTest scans directories that were added via
:obj:`~cmake_test/add_dir.ct_add_dir` and generates a bootstrap CTest test file
for each CMake file in each directory. The bootstrap file is generated from a
template, which is explained in :ref:`Bootstrap Templates`.

==========
Test Stage
==========
The test stage is the phase in which the majority of CMakeTest
code is executed. The generated bootstrap files handle the setup of the CMakeTest
runtime. From there the bootstrap sequence begins the test discovery and execution
procedure.

--------------
Test Discovery
--------------
Tests are discovered by :code:`include()`-ing the file under test,
which will execute all top-level :obj:`~cmake_test/add_test.ct_add_test` calls.
These calls instantiate one :obj:`~cmake_test/execution_unit.CTExecutionUnit`
object each and add it to a :code:`CMAKETEST_TEST_INSTANCES` CMakePP global list.
This initial discovery procedure does not discover subsections of tests.

--------------
Test Execution
--------------
Once all tests are discovered, they are then executed via
:obj:`~cmake_test/exec_tests.ct_exec_tests`. This function first
registers the global exception handler using
:obj:`~cmake_test/register_exception_handler.ct_register_exception_handler`
and then loops over the execution
units stored in :code:`CMAKETEST_TEST_INSTANCES`, calling the associated
:obj:`~cmake_test/execution_unit.CTExecutionUnit.execute` method.

The :code:`execute()` method is the meat of the test execution.
It begins by setting some needed globals, and then checks if the
test is :code:`EXPECTFAIL`. If so, the test is executed via
:obj:`~cmake_test/expectfail_subprocess.ct_expectfail_subprocess`.
Otherwise, the test is executed via calling the function
directly using CMakePP's :code:`cpp_call_fxn()` command.

During the test execution, subsections are discovered
but not executed. The discovery happens in a similar vein as
the test discovery, i.e. :obj:`~cmake_test/add_section.ct_add_section`
instantiates a new execution unit and adds it to the currently-executing
unit's :obj:`~cmake_test/execution_unit.CTExecutionUnit.children` map.

Once the test has finished executing, a pass line is printed if no errors were
detected. The test's subsections are then executed via the unit's
:obj:`~cmake_test/execution_unit.CTExecutionUnit.exec_sections` method.


---------------------------
Error Catching and Recovery
---------------------------
CMake does not have any concept of error recovery,
any :code:`message(FATAL_ERROR ...)` call will immediately terminate
the interpreter. CMakeTest must be able to catch these errors,
log the error and label the test as failing, and continue executing tests.
Additionally, CMakePP includes a form of exceptions that also need to be
caught before they result in interpreter termination. The biggest problem
with these exceptions is that they cannot unwind the stack, so once the exception
handler returns the execution continues unabated from the throw point.

CMakeTest handles these problems using a few somewhat-"hacky" tricks.
The first of these tricks overrides the builtin :code:`message()` function
with a custom one (:obj:`cmake_test/overrides.message`). This override
converts all :code:`FATAL_ERROR` messages to CMakePP exceptions. This allows
all vanilla CMake code running under tests to error without immediately terminating
the interpreter, including code in external modules.

The second trick exists in the exception handler registered by
:obj:`~cmake_test/register_exception_handler.ct_register_exception_handler`.
The handler is registered for all exceptions, which means it also handles
the generic exceptions generated by our :code:`message()` override.
When the handler catches an exception it checks the execution unit that
is currently running (tracked by a global), sets the
:obj:`~cmake_test/execution_unit.CTExecutionUnit.has_printed` and
:obj:`~cmake_test/execution_unit.CTExecutionUnit.has_executed`
attributes to true, and then calls
:obj:`~cmake_test/exec_tests.ct_exec_tests` again.

This may seem counter-intuitive, but by restarting the execution
and by checking the previously-set variables we can selectively
skip tests that have already ran and only run those that have not ran.
This works around the inability to unwind the stack. Once the
:code:`ct_exec_tests()` call returns we call
:obj:`~cmake_test/overrides.ct_exit` to terminate the interpreter,
which prevents the code up the stack from continuing.