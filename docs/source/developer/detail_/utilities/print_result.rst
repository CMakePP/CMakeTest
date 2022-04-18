
####################################
detail_/utilities/print_result.cmake
####################################

.. module:: detail_/utilities/print_result.cmake


.. function:: _ct_print_result(_pr_name _pr_result _pr_depth _pr_print_length)
   Wraps the process of printing a test's result
   
    This function largely serves as code factorization for ``_ct_print_pass`` and
    ``_ct_print_fail``. This function will print an indent appropriate for the
    current nesting, and then enough dots to right align the result.
   
    :param _pr_name: The name of the test we are printing the result of.
    :type _pr_name: str
    :param _pr_result: What to print as the result (usually "PASSED" or "FAILED")
    :type _pr_result: str
    :param _pr_depth: How many sections is this test nested?
    :type _pr_depth: str
    :param _pr_print_length: The total length of the line to be printed, including dots and whitespace
    :type _pr_print_length: int
   


.. function:: _ct_print_fail(_pf_name _pf_depth _pf_print_length)
   Wraps the process of printing that a test failed.
   
   This function is called after one or more asserts on a test have failed. When
   called this function will print to the standard output that the test failed.
   It will then print any additional content passed via `${ARGN}` assuming it is
   the reason why the test failed. Finally, this function will issue a fatal
   error stopping the test.
   
   :param _pf_name: The name of the test that just failed.
   :type _pf_name: str
   :param _pf_depth: How many sections is this test nested?
   :type _pf_depth: str
    :param _pf_print_length: The total length of the line to be printed, including dots and whitespace
    :type _pf_print_length: int
   

