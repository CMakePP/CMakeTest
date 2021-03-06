include_guard()

#[[[ Syntactic sugar for returning a value from a function
#
# CMake allows you to return variables by adding them to the parent namespace.
# The best way to do this is to have the callee provide the function with an
# identifier to save the result to. This function wraps the common case where
# internally the function saves the result to a local variable with the same
# name as the callee provided for the result. Without the ``_ct_return``
# function this pattern looks something like:
#
# .. code-block:: cmake
#
#    function(fxn_name return_identifier)
#        set(${return_identifier} "the value")
#        set(${return_identifier} ${${return_identifier}} PARENT_SCOPE
#    endfunction()
#
# With the ``_ct_return`` function the above becomes:
#
# .. code-block:: cmake
#
#    function(fxn_name return_identifier)
#        set(${return_identifier} "the value")
#        _ct_return(${return_identifier})
#    endfunction()
#
# While the new code still has the same number of lines, it is our opinion that
# the new code is easier to read and the intent is more clear.
#
# :param _r_var: The identifier which needs to be set in the parent namespace.
# :type _r_var: Identifier
#
# ..note::
#
#   This function is a macro to avoid creating another scope. If ``function``
#   is used the identifier will be set in the scope of the function that
#   called ``_ct_return`` and NOT in the scope of the function that called the
#   callee of ``_ct_return``.
#]]
macro(_ct_return _r_var)
    set(${_r_var} "${${_r_var}}" PARENT_SCOPE)
endmacro()
