include_guard()

#FUNCTION
#
# This function is the guts of adding a new assert for a section. It looks at
# the number of sections and the number of asserts. If the number of sections
# is one greater than the number of asserts then we know that this is the first
# assert for that section. If, however, the number of sections and the number of
# asserts are equal than we are adding an additional check to a test. If neither
# of the previous options are true the user has added sections without adding
# asserts, or is adding asserts without adding a section; either way it's an
# error.
function(_ct_add_assert _aa_name _aa_input)
    list(LENGTH _ct_internal_asserts _ct_n_asserts)
    set(_aa_n_sec ${_ct_internal_n_sections})
    math(EXPR _aa_need_to_add "${_aa_n_sec} - 1")

    if("${_ct_n_asserts}" STREQUAL "${_aa_need_to_add}") #First assert
        list(APPEND _ct_internal_asserts "${_aa_name}")
        list(APPEND _ct_internal_assert_input "${_aa_input}")
    elseif("${_ct_n_asserts}" STREQUAL "${_aa_n_sec}") #Add
        list(GET _ct_internal_asserts ${_aa_n_sec} _aa_contents)
        set(_aa_contents "${_aa_contents}\\\;${_aa_name}")
        list(INSERT _ct_internal_asserts ${_aa_n_sec} "${_aa_contents}")
        list(GET _ct_internal_assert_inputs ${_aa_n_sec} _aa_inputs)
        set(_aa_inputs "${_aa_inputs}\\\;${_aa_input}")
        list(INSERT _ct_internal_assert_inputs ${_aa_n_sec} "${_aa_inputs}")
    endif()
    set(_ct_internal_asserts "${_ct_internal_asserts}" PARENT_SCOPE)
    set(_ct_internal_assert_inputs "${_ct_internal_assert_inputs}" PARENT_SCOPE)
endfunction()
