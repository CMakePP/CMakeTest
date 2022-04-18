
####################
asserts/string.cmake
####################

.. module:: asserts/string.cmake


.. function:: ct_assert_string(_as_var)
   Asserts that an identifier contains a string
   
   For our purposes a string is anything that is not a list (a list being a
   string that contains at least one unescaped semicolon). This function will
   raise an error if the provided identifier is not a string. Consequentially,
   this function is more-or-less equivalent to ct_assert_not_list.
   
   :param _as_var: The identifier we want the stringy-ness of.
   :type _as_var: Identifier
   


.. function:: ct_assert_not_string(_ans_var)
   Asserts that an identifier does not contain a string
   
   For our purposes a string is anything that is not a list (a list being a
   string that contains at least one unescaped semicolon). This function will
   raise an error if the provided identifier is a string. Consequentially, this
   function is more-or-less equivalent to ct_assert_list.
   
   :param _ans_var: The identifier we want the stringy-ness of.
   :type _ans_var: Identifier
   

