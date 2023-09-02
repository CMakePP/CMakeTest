# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#[[[ @module
# This module provides an option called :code:`CMAKETEST_USE_COLORS`
# and a set of global variables to use to color terminal output.
# These global constants are just one-to-one constants of specific ANSI
# control codes. If :code:`CMAKETEST_USE_COLORS` is not set to true or
# if the OS is Windows (cmd doesn't support ANSI control codes),
# these constants will not be defined and should resolve to an empty string.
#
# Example:
#
# .. code:: cmake
#    set(example "${CT_Red}This will be red if the option is set${CT_ColorReset}")
#]]

include_guard()

#[[[
# Enable colors in Unix environments, ignored on Windows.
# Will output garbage for pipes and text files. If false, all constants in this
# file are not defined, so will resolve to
# the empty string.
#]]
option(
    CMAKETEST_USE_COLORS
    "This option enables coloration in CMakeTest output. If enabled will mangle log files or pipes that do not support coloration. This option is ignored on Windows."
    "FALSE"
)

if(NOT WIN32 AND CMAKETEST_USE_COLORS)
  #[[[
  # The character used to start the ANSI control code.
  #]]
  string(ASCII 27 Esc)

  #[[[
  # Resets the color to the terminal default.
  #]]
  set(CT_ColorReset "${Esc}[m")

  #[[[
  # Sets the text that follows to be bold.
  #]]
  set(CT_ColorBold  "${Esc}[1m")

  #[[[
  # Sets the text color to red.
  #]]
  set(CT_Red         "${Esc}[31m")

  #[[[
  # Sets the text color to green.
  #]]
  set(CT_Green       "${Esc}[32m")

  #[[[
  # Sets the text color to yellow.
  #]]
  set(CT_Yellow      "${Esc}[33m")

  #[[[
  # Sets the text color to blue.
  #]]
  set(CT_Blue        "${Esc}[34m")

  #[[[
  # Sets the text color to magenta.
  #]]
  set(CT_Magenta     "${Esc}[35m")

  #[[[
  # Sets the text color to cyan.
  #]]
  set(CT_Cyan        "${Esc}[36m")

  #[[[
  # Sets the text color to white.
  #]]
  set(CT_White       "${Esc}[37m")

  #[[[
  # Sets the text color to bold red.
  #]]
  set(CT_BoldRed     "${Esc}[1;31m")

  #[[[
  # Sets the text color to bold green.
  #]]
  set(CT_BoldGreen   "${Esc}[1;32m")

  #[[[
  # Sets the text color to bold yellow.
  #]]
  set(CT_BoldYellow  "${Esc}[1;33m")

  #[[[
  # Sets the text color to bold blue.
  #]]
  set(CT_BoldBlue    "${Esc}[1;34m")

  #[[[
  # Sets the text color to bold magenta.
  #]]
  set(CT_BoldMagenta "${Esc}[1;35m")

  #[[[
  # Sets the text color to bold cyan.
  #]]
  set(CT_BoldCyan    "${Esc}[1;36m")

  #[[[
  # Sets the text color to bold white.
  #]]
  set(CT_BoldWhite   "${Esc}[1;37m")
endif()
