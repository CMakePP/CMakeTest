#TUTORIAL
#
#This tutorial will introduce you to the concept of sections. Sections allow you
#to establish testing scopes. The contents of a testing scope are not visible to
#CMake code outside of that testing scope. Scopes can be nested with inner
#scopes having acess to the outer scope's state. Changes made in inner scopes
#will not affect unit tests outside of the inner scope. This provides a
#straightforward mechanism for unit testing changes in isolation, namely:
#
#- create an initial state,
#- verify the initial state is correct,
#- introduce a subsection/inner scope
#- in the inner scope: modify the state
#- in the inner scope: verify the state
#- return to outer scope, undoing all changes in the inner scope
#
#These ideas are a bit abstract and can likely be made much clearer with a code
#example. We start by defining our unit test, a variable that will be visible
#to all inner scopes, and an assert to prove that the variable has the state we
#think it does.
include(cmake_test/cmake_test)
ct_add_test(NAME "_test_sections")
function(${CMAKETEST_TEST})
    set(common "This variable is available to all tests")
    ct_assert_equal(common "This variable is available to all tests")

    #TUTORIAL
    #
    #If you are reading the tutorials in order, ``ct_assert_equal`` is a new
    #assert. ``ct_assert_equal`` will assert that the identifier recieved via
    #its first argument contains the value provided by its second argument. Its
    #more-or-less equivalent to the following CMake code:
    #
    #.. code-block:: cmake
    #
    #   if("${common}" STREQUAL "This variable is available to all tests")
    #       # Assert passes
    #   else()
    #       # Assert fails
    #   endif()
    #
    #with some additional bells and whistles specific to unit testing.
    #
    #To illustrate the concept of scope we now introduce the inner scope. This
    #is done with the commands
    #``ct_add_section`` and ``endfunction``. To the user, for all intents and
    #purposes ``ct_add_section`` (``endfunction``) is the same as
    #``ct_add_test`` (``ct_end_test``). Behind the scenes, however, the
    #functions behave slightly different. If suffices to remember that the
    #outermost scope must always be created with ``ct_add_test`` and ended with
    #``ct_end_test``, whereas all inner scopes (even scopes within sections) are
    #started with ``ct_add_section`` and ended with ``endfunction``.
    ct_add_section(NAME "_scoped_variable")
    function(${CMAKETEST_SECTION})

        #TUTORIAL
        #
        #You can override the default print length for tests and subsections
        #by calling this function. It will be propagated down, so if it's
        #not overriden again subsequent subsections will use the new print length.
        ct_set_print_length(120)

        set(not_common "Only visible to this and nested sections.")
        ct_assert_equal(common "This variable is available to all tests")
        ct_assert_equal(not_common "Only visible to this and nested sections.")

        #TUTORIAL
        #
        #You can nest sections to your heart's content (realistically there is
        #of course some limit, but it is imposed by available resources and not
        #CMakeTest).
        #You can also forcibly override the print length for this section and subsequent
        #sections by setting the PRINT_LENGTH option. This option overrides any length
        #set by parents or by the ct_set_print_length() macro.
        #Priority for print length is as follows (first most important):
        # 1. This section's PRINT_LENGTH option
        # 2. Parent's PRINT_LENGTH option
        # 3. Length set by ct_set_print_length()
        # 4. Built-in default of 80.
        ct_add_section(NAME "_nested_section" PRINT_LENGTH 180)
        function(${CMAKETEST_SECTION})
            set(not_common "This change only matters here")
            ct_assert_equal(common "This variable is available to all tests")
            ct_assert_equal(not_common "This change only matters here")
        endfunction()

        #TUTORIAL
        #
        #Sections are parsed on-the-fly. In other words, the following contents
        #will not be visible to the previous nested section, but will be visible
        #to the following subsection.
        ct_assert_equal(not_common "Only visible to this and nested sections.")
        set(not_common "Only visible from here forward")

        ct_add_section(NAME "_another_nested_section")
        function(${CMAKETEST_SECTION})
            ct_assert_equal(not_common "Only visible from here forward")
        endfunction()
    endfunction()

    #TUTORIAL
    #
    #Code at the test case scope works exactly like code in a section. In other
    #words the following code is only visible from here forward.
    ct_assert_equal(common "This variable is available to all tests")
    set(common "Only visible from here forward")
    ct_assert_equal(common "Only visible from here forward")
endfunction()

#TUTORIAL
#
#To make the above even more concrete. You can think of this unit test as
#defining the following four ``CMakeLists.txt`` and running each of them with a
#separate invocation of the CMake command (in a clean directory, with a clean
#build directory, a fresh CMake caches, etc.).
#
#The first test is ``Sections: Make a Scoped Variable: Nested Section``:
#
#.. code-block:: cmake
#
#    set(common "This variable is available to all tests")
#    ct_assert_equal(common "This variable is available to all tests")
#    set(not_common "Only visible to this and nested sections.")
#    ct_assert_equal(common "This variable is available to all tests")
#    ct_assert_equal(not_common "Only visible to this and nested sections.")
#    set(not_common "This change only matters here")
#    ct_assert_equal(common "This variable is available to all tests")
#    ct_assert_equal(not_common "This change only matters here")
#
#The second test is
#``Sections: Make a Scoped Variable: Another Nested Section``:
#
#.. code-block:: cmake
#
#    set(common "This variable is available to all tests")
#    ct_assert_equal(common "This variable is available to all tests")
#    set(not_common "Only visible to this and nested sections.")
#    ct_assert_equal(common "This variable is available to all tests")
#    ct_assert_equal(not_common "Only visible to this and nested sections.")
#    ct_assert_equal(not_common "Only visible to this and nested sections.")
#    set(not_common "Only visible from here forward")
#
#The third test is ``Sections: Make a Scoped Variable``:
#
#.. code-block:: cmake
#
#    set(common "This variable is available to all tests")
#    ct_assert_equal(common "This variable is available to all tests")
#    set(not_common "Only visible to this and nested sections.")
#    ct_assert_equal(common "This variable is available to all tests")
#    ct_assert_equal(not_common "Only visible to this and nested sections.")
#
#And the fourth test is ``Sections``:
#
#.. code-block:: cmake
#
#    set(common "This variable is available to all tests")
#    ct_assert_equal(common "This variable is available to all tests")
#    ct_assert_equal(common "This variable is avaialable to all tests")
#    set(common "Only visible from here forward")
#    ct_assert_equal(common "Only visible from here forward")
#
#Basically everytime parsing hits a ``endfunction`` or ``ct_end_test``
#command a new unit test is spun off.
