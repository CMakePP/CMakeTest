
#####################################
detail_/utilities/sanitize_name.cmake
#####################################

.. module:: detail_/utilities/sanitize_name.cmake


.. function:: _ct_sanitize_name(_sn_new_name _sn_old_name)
   Makes the provided name more filesystem friendly
   
   CMakeTest will need to turn test names into file names in a few places. This
   requires the test name to be filesystem friendly. More specifically we:
   
   - Make the string lowercase
   - Replace spaces with underscores
   - Replace colons with hyphens
   
   :param _sn_new_name: An identifier to which the new name will be assigned
   :type _sn_new_name: Identifier
   :param _sn_old_name: The string that we are sanitizing.
   :type _sn_old_name: str
   :returns: A string containing the sanitized name. The result is accessible to
             the caller via ``_sn_new_name``.
   

