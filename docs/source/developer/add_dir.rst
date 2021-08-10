
#############
add_dir.cmake
#############

.. module:: add_dir.cmake


.. function:: ct_add_dir(_ad_dir)

   

   This function will find all *.cmake files in the specified directory as well as recursively through all subdirectories.

   It will then configure the boilerplate template to include() each cmake file and register each configured boilerplate

   with CTest. The configured templates will be executed seperately via CTest during the Test phase, and each *.cmake

   file found in the specified directory is assumed to contain CMakeTest tests.

   

   :param _ad_dir: The directory to search for *.cmake files. Subdirectories will be recursively searched.

   :type _ad_dir: path

   

   

