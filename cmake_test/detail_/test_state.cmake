include_guard()
include(cmake_test/detail_/utilities)




## @memberof TestState
#  @private
#  @fn _ct_name_mangle(mangled_name, target, attribute)
#  @brief Handles name mangling for the TestState class
#
# This function wraps the details of how we mangle our target's attributes.
# Ultimately when we want to create or access our target's attributes we
# rely on this function to mangle the name for us. This function is not part of
# the public API of the test_state class.
#
# @param[out] mangled_name Variable name to assign the mangled name to.
# @param[in] target The handle to the TargetState object
# @param[in] attribute The name of the attribute we want a mangled name for.
function(_ct_name_mangle _nm_mangled_name _nm_target _nm_attribute)
    set(${_nm_mangled_name} "${_nm_target}_${_nm_attribute}")
    _ct_return(_nm_mangled_name)
endfunction()

## @memberof TestState
#  @private
#
function(_ct_add_prop _ap_target _ap_name _ap_default_value)
    _ct_variable_is_set(_ap_target "Must provide a handle")
    _ct_variable_is_set(_ap_name "Must provide a name")


    _ct_name_mangle(_ap_handle "${_ap_target}" "${_ap_name}")
    set_property(GLOBAL PROPERTY "${_ap_handle}" "${_ap_default_value}")
endfunction()

function(_ct_get_prop _gp_value _gp_target _gp_name)
    _ct_variable_is_set(_gp_value "Must provide an output variable")
    _ct_variable_is_set(_gp_target "Must provide handle")
    _ct_variable_is_set(_gp_name "Must provide property name")

    _ct_name_mangle(_gp_handle "${_gp_target}" "${_gp_name}")
    get_property(${_gp_value} GLOBAL PROPERTY "${_gp_handle}")
    _ct_return(_gp_value)
endfunction()

function(_ct_test_state_ctor _tsc_handle _tsc_name)
    _ct_variable_is_set(_tsc_handle "Returned object name can not be empty")
    _ct_variable_is_set(_tsc_name "Test name can not be empty")

    string(RANDOM _tsc_temp_handle) #Basically our this pointer

    # Add properties to our class

    #The name of the test from the add_test command
    _ct_add_prop("${_tsc_temp_handle}" "test_name" "${_tsc_name}")

    # A running total of the number of tests we've added
    _ct_add_prop("${_tsc_temp_handle}" "test_number" 0)

    # A list of section titles we've come across length of which is our depth
    # + 1
    _ct_add_prop("${_tsc_temp_handle}" "section_titles" "")

    # A list of content by depth
    _ct_add_prop("${_tsc_temp_handle}" "test_content" "")

    set(${_tsc_handle} ${_tsc_temp_handle})
    _ct_return(_tsc_handle)
endfunction()

function(_ct_test_state_get_title _tsgt_handle _tsgt_title)
    _ct_get_prop(_tsgt_titles "${_tsgt_handle}" "section_titles")
    list(LENGTH _tsgt_titles _tsgt_length)
    set(_tsgt_counter 0)
    set(${_tsgt_title} "")
    while("${_tsgt_counter}" LESS "${_tsgt_length}")
        list(GET _tsgt_titles ${_tsgt_counter} _tsgt_part)
        set(${_tsgt_title} "${${_tsgt_title}}${_tsgt_part} : ")
        math(EXPR _tsgt_counter "${_tsgt_counter} + 1")
    endwhile()
    _ct_return(_tsgt_title)
endfunction()

function(_ct_test_state_get_content _tsgc_handle _tsgc_content)
    _ct_get_prop(_tsgc_test_content "${_tsgc_handle}" "test_content")
    list(LENGTH _tsgc_test_content _tsgc_length)
    set(_tsgc_counter 0)
    set(${_tsgc_content} "")
    while("${_tsgc_counter}" LESS "${_tsgc_length}")
        list(GET _tsgc_test_content ${_tsgc_counter} _tsgc_part)
        set(${_tsgc_content} "${${_tsgc_content}}\n${_tsgc_part}")
        math(EXPR _tsgc_counter "${_tsgc_counter} + 1")
    endwhile()
    _ct_return(_tsgc_content)
endfunction()

function(_ct_test_state_current_depth _tscd_handle _tscd_depth)
    _ct_variable_is_set(_tscd_handle "Must provide a handle.")
    _ct_variable_is_set(_tscd_depth  "Must provide a return name.")

    _ct_get_prop(_tscd_titles ${_tscd_handle} "section_titles")
    list(LENGTH _tscd_titles ${_tscd_depth})
    _ct_return(_tscd_depth)
endfunction()

function(_ct_test_state_add_content _tsac_handle _tsac_content)
    _ct_test_state_current_depth("${_tsac_handle}" _tsac_depth)
    _ct_get_prop(_tsac_test_content ${_tsac_handle} "test_content")
    list(LENGTH _tsac_test_content _tsac_length)
    if("${_tsac_depth}" LESS "${_tsac_length}") #In range [0, N)
        list(GET _tsac_test_content ${_tsac_depth} _tsac_elem)
        set(_tsac_elem "${_tsac_elm}${_tsac_content}")
        list(INSERT _tsac_test_content ${_tsac_depth} "${_tsac_elem}")
    elseif(NOT "${_tsac_length}" STREQUAL "0") # >= N and list is not empty
        message(FATAL_ERROR "${_tsac_depth} not in range [O, ${_tsac_length})")
    else() #List is empty or depth is negative (don't think latter is possible)
        set(_tsac_test_content "${_tsac_content}")
    endif()
    _ct_add_prop("${_tsac_handle}" "test_content" "${_tsac_test_content}")
endfunction()

#FUNCTION
#
# Function for printing out the current state of a TestState class instance.
#
# :param: handle The handle to the TestState class we want to print out. Can not
#                be blank.
function(_ct_test_state_print _tsp_handle)
    _ct_variable_is_set(_tsp_handle "Must provide a valid handle")

    # Loop over single value attributes
    foreach(_tsp_attribute "test_name" "test_number")
        _ct_get_prop(_tsp_buffer "${_tsp_handle}" "${_tsp_attribute}")
        message("${_tsp_attribute}: ${_tsp_buffer}")
    endforeach()

    _ct_test_state_current_depth(${_tsp_handle} _tsp_depth)
    message("Current depth: ${_tsp_depth}")

    _ct_test_state_get_title(${_tsp_handle} _tsp_section)
    message("Current section title: ${_tsp_section}")

    _ct_test_state_get_content(${_tsp_handle} _tsp_content)
    message("Current section content: ${_tsp_content}")
endfunction()

## @class TestState test_state cmake_test/detail_/test_state.cmake
#
#  @brief Class for holding the state of the test
#
#  The TestState class holds the state of the test that is currently being
#  parsed. While we document and use it as if it is a class it is important to
#  realize it's not really a class (even in the CMakePP object sense). The
#  decision to not use a CMakePP object was made in order to keep CMakeTest
#  stand alone. In particular this means:
#
#  - Public, Private, and protected are conventions, not rigorously enforced
#  -

macro(test_state fxn)
    if("${fxn}" STREQUAL "CTOR")
        _ct_test_state_ctor(${ARGN})
    elseif("${fxn}" STREQUAL "PRINT")
        _ct_test_state_print(${ARGN})
    elseif("${fxn}" STREQUAL "ADD_CONTENT")
        _ct_test_state_add_content(${ARGN})
    else()
        message(FATAL_ERROR "Class TestState has no member: ${fxn}")
    endif()
endmacro()
