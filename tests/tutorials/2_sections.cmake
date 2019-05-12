#TUTORIAL
#
# This tutorial will introduce you to the concept of sections. Sections allow
# the creation of testing scope. The contents of a section are tested in
# isolation from all other unit tests.
#
# As with all unit testing with CMakeTest, the first step is to include the
# CMakeTest module, which is located in the file ``cmake_test/cmake_test.cmake``
include(cmake_test/cmake_test)
set(CT_DEBUG_RESULT TRUE)
#TUTORIAL
#
# Next we declare a test case. All unit tests in CMakeTest must be included in
# in a test case.
ct_add_test("Sections")

    #TUTORIAL
    #
    # Code in the ``ct_add_test`` block that is not included in a section is
    # common to all unit tests. The next line makes a variable ``common``
    # available to all unit tests.
    set(common "This variable is available to all tests")

    #TUTORIAL
    #
    # Content at block scope in a unit test is usually things like ``include``
    # commands. In order to ensure that your code is running correctly you want
    # to run each part of the unit test in isolation. Sections allow you to
    # define scopes. Here we make a section that introduces a variable
    # ``not_common``.
    ct_add_section("Make a scoped variable")
        set(not_common "Only visible to this and nested sections.")

        #TUTORIAL
        #
        # If you have been following the tutorials in order you have only seen
        # the assert which ensures that a particular message prints. Another
        # common assert is ``assert_equal``, which asserts that a variable has
        # a particular value. Here we prove to you that ``common`` is in scope
        # as is ``not_common``.
        ct_assert_equal(common "This variable is available to all tests")
        ct_assert_equal(not_common "Only visible to this and nested sections.")

        #TUTORIAL
        #
        # You can nest sections to your heart's content (you can not nest test
        # cases; however, you may have as many test cases as you like). Each
        # nested section introduces a new scope that is the union of the test
        # case's scope and the scopes of each parent section.
        ct_add_section("Nested section")
            set(not_common "This change only matters here")
            ct_assert_equal(common "This variable is available to all tests")
            ct_assert_equal(not_common "This change only matters here")

        #TUTORIAL
        #
        # Like ``ct_add_test``, each section must be closed with a
        # ``ct_end_section`` call.
        ct_end_section()

        #TUTORIAL
        #
        # Sections are parsed on-the-fly. In other words, if you continue a
        # section after a nested section, those changes will not be visible to
        # the previous nested sections, but they will be visible to future
        # nested sections. This is probably clearer with an example. First we
        # prove that ``not_common`` has its old value, then we change this
        # value and show that the next nested subsection sees the new value.
        ct_assert_equal(not_common "Only visible to this and nested sections.")
        set(not_common "Only visible from here forward")

        ct_add_section("Another nested section")
            ct_assert_equal(not_common "Only visible from here forward")
        ct_end_section()
    ct_end_section()

    #TUTORIAL
    #
    # Code at test case scope following a section works exactly like code in a
    # section that follows a nested section. In other words ``common`` still has
    # its same value, if we change this value it will not break the previous
    # sections.
    ct_assert_equal(common "This variable is avaialable to all tests")

    set(common "Only visible from here forward")
    ct_assert_equal(common "Only visible from here forward")

    #TUTORIAL
    #
    # We conclude this tutorial by proving to you that the variable
    # ``not_common`` is not defined. That is to say, the changes in the sections
    # also do not affect the test case scope.
    ct_assert_not_defined(not_common)
ct_end_test()
