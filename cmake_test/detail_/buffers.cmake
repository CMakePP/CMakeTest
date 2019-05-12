include_guard()

function(_ct_make_test _mt_handle _mt_name)

endfunction()

function(_ct_make_section _ms_handle _ms_name)
    get_target_property(_ms_names ${_ms_handle} TEST_NAME)
    list(LENGTH _ms_names _ms_depth)
    if("${_ms_depth}" STREQUAL "0")



function(_ct_append_buffer_guts _ab_buffer _ab_line)
    cmake_policy(SET CMP0007 NEW) #List won't ignore empty elements
    list(LENGTH ${_ab_buffer} _ab_n)
    _ct_parse_debug("Old ${_ab_buffer} value: ${${_ab_buffer}}")
    if("${_ab_n}" STREQUAL 0)
        set(${_ab_buffer} "${${_ab_buffer}}${_ab_line}" PARENT_SCOPE)
    else()
        list(GET ${_ab_buffer} -1 _ab_item)
        set(_ab_item_ "${_ab_item}${_ab_line}")
        list(INSERT ${_ab_buffer} -1 "${_ab_item}")
        set("${_ab_buffer}" "${${_ab_buffer}}" PARENT_SCOPE)
    endif()
    _ct_parse_debug("New ${_ab_buffer} value: ${${_ab_buffer}}${_ab_line}")
endfunction()

macro(_ct_append_buffer _ab_buffer _ab_line)
    _ct_append_buffer_guts(${_ab_buffer} "${_ab_line}")
    set(${_ab_buffer} "${${_ab_buffer}}" PARENT_SCOPE)
endmacro()

macro(_ct_recurse_buffer _rb_buffer _rb_initial)
    list(APPEND ${_rb_buffer} "${_rb_initial}")
    set(${_rb_buffer} "${${_rb_buffer}}" PARENT_SCOPE)
endmacro()

macro(_ct_recurse_buffers)
    _ct_recurse_buffer(_ct_test_name "")
    _ct_recurse_buffer(_ct_contents "")
    _ct_recurse_buffer(_ct_prints "")
    _ct_recurse_buffer(_ct_should_pass TRUE)
endmacro()

macro(_ct_pop_buffer _pb_buffer)
    list(LENGTH ${_pb_buffer} _pb_n)
    if("${_pb_n}" STREQUAL "0")
        message(FATAL_ERROR "Did you forget a ct_start_section?")
    endif()
    list(REMOVE_AT ${_pb_buffer} -1)
    set(${_pb_buffer} ${${_pb_buffer}} PARENT_SCOPE)
endmacro()

macro(_ct_pop_buffers)
    _ct_pop_buffer(_ct_test_name)
    _ct_pop_buffer(_ct_contents)
    _ct_pop_buffer(_ct_prints)
    _ct_pop_buffer(_ct_should_pass)
endmacro()

function(_ct_check_empty _ce_buffer)
    list(LENGTH ${_ce_buffer} _ce_n)
    if(NOT "${_ce_n}" STREQUAL "0")
        message(FATAL_ERROR "Did you forget to call ct_end_section?")
    endif()
endfunction()

function(_ct_assert_empty)
    _ct_check_empty(_ct_test_name)
    _ct_check_empty(_ct_contents)
    _ct_check_empty(_ct_prints)
    _ct_check_empty(_ct_should_pass)
endfunction()
