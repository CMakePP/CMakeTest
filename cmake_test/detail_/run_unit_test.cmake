include_guard()

function(_rut_debug_print)
    if(_rut_debug)
        message("${ARGN}")
    endif()
endfunction()

function(_ct_run_unit_test _rut_file)
    set(_rut_debug TRUE)
    _rut_debug_print("Parsing file: ${_rut_file}")
    file(READ ${_rut_file} _rut_contents)
    _rut_debug_print("File contents:\n ${_rut_contents}")
endfunction()
