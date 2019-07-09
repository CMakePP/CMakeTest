include_guard()

## @fn _ct_return(var)
#  @brief Syntactic sugar for returning a value from a function
#
#  CMake allows you to return variables by adding them to the parent namespace.
#  The best way to do this is to have the callee provide the function with an
#  identifier to save the result to. This function wraps the common case where
#  internally the function saves the result to a local variable with the same
#  name as the callee provided for the result. Typically that looks something
#  like:
#
#  @code
#  function(fxn_name return_identifier)
#      set(${return_identifier} "the value")
#      set(${return_identifier} ${${return_identifier}} PARENT_SCOPE
#  endfunction()
#  @endcode
#
#  With this function the above becomes:
#
#  @code
#  function(fxn_name return_identifier)
#      set(${return_identifier} "the value")
#      _ct_return(${return_identifier})
#  endfunction()
#  @endcode
#
#  @param[in,out] var The identifier which needs to be set in the parent
#                     namespace. Whatever value the identifier @p var is set to
#                     when _ct_return is called will be the value in the parent
#                     namespace.
#
#  @note This function is a macro to avoid creating another scope. If `function`
#        is used the identifier will be set in the scope of the function that
#        called _ct_return and NOT the scope of the function that called the
#        function that called _ct_return.
macro(_ct_return _r_var)
    set(${_r_var} "${${_r_var}}" PARENT_SCOPE)
endmacro()
