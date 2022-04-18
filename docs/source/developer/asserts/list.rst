
##################
asserts/list.cmake
##################

.. module:: asserts/list.cmake


.. function:: ct_assert_list(_al_var)
   Asserts that an identifier contains a list.
   
   For our purposes a list is defined as a string that contains one or more,
   unescaped semicolons. While a string with no semicolons is usable as if it is
   a single element list (or a zero element list if it is the empty string) this
   function will not consider such strings lists. If the identifier is not a list
   an error will be raised.
   
   :param _anl_var: The identifier we want to know the list-ness of.
   :type _anl_var: Identifier
   


.. function:: ct_assert_not_list(_anl_var)
   Asserts that an identifier does not contain a list.
   
   For our purposes a list is defined as a string that contains one or more,
   unescaped semicolons. While a string with no semicolons is usable as if it is
   a single element list (or a zero element list if it is the empty string) this
   function will not consider such strings lists. If the provided string is a
   list this function will raise an error.
   
   :param _anl_var: The identifier we want to know the list-ness of.
   :type _anl_var: Identifier
   

