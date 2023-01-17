include_guard()

include(cpp/cpp)

#[[[
#
# CTExecutionUnit represents the basic atomic unit of tests.
# Units can be either tests or test sections.
# The unit stores and tracks all state information
# related to the unit, such as the test ID, its friendly
# name, the file that contains it, etc.
#
# This class also contains useful instance methods
# for generating or modifying required information.
#
# An execution unit must be linked to an accompanying
# function that will be executed when this unit is tested.
#
#]]
cpp_class(CTExecutionUnit)

        #[[[
        # Stores the unique ID of the unit.
        # This value is autogenerated and
        # is used to name the function
        # this unit is linked to.
        #]]
	cpp_attr(CTExecutionUnit test_id)

        #[[[
        # The "friendly name" of the execution unit.
        # This is equivalent to the NAME parameter
        # when calling ct_add_test() or ct_add_section().
        # Dereferencing the value of this field
        # will yield the ID of this unit while in the
        # scope of the unit.
        #]]
	cpp_attr(CTExecutionUnit friendly_name)

        #[[[
        # The full path that points to the file containing
        # this unit's declaration. This value is propagated
        # down from the root test to all sections and subsections.
        #]]
	cpp_attr(CTExecutionUnit test_file)

        #[[[
        # A boolean describing whether this unit is intended
        # to fail or not. Directly related to the parameter
        # of the same name in ct_add_test() and ct_add_section().
        #]]
	cpp_attr(CTExecutionUnit expect_fail)

        #[[[
        # A reference pointing to the parent execution unit
        # of this unit. This will be empty for the root test
        # and filled for all subsections.
        #]]
	cpp_attr(CTExecutionUnit parent)

        #[[[
        # A map between IDs and references to unit instances
        # used to represent the subsections of this unit.
        #]]
	cpp_attr(CTExecutionUnit children)

        #[[[
        # The length to use for printing in the context of this
        # unit and any subsections that do not override it.
        # This value can be set by the parameter of the same name
        # in ct_add_test() and ct_add_section(). It can also be set
        # via an overriding cache variable.
        #]]
	cpp_attr(CTExecutionUnit print_length "${CT_PRINT_LENGTH}")

        #[[[
        # Describes whether the print length was forced via the call
        # to ct_add_test() or ct_add_section() that constructed
        # this unit.
        #]]
	cpp_attr(CTExecutionUnit print_length_forced FALSE)

        #[[[
        # A boolean describing whether or not this unit
        # should loop over and execute all of its subsections.
        #]]
        cpp_attr(CTExecutionUnit execute_sections FALSE)

        #[[[
        # A map linking section friendly names to Ids so the
        # id isn't lost between the first and second invocation passes.
        #]]
        cpp_attr(CTExecutionUnit section_names_to_ids)

        #[[[
        # A list containing messages representing any exceptions
        # that occurred during the execution of this unit.
        #]]
        cpp_attr(CTExecutionUnit exceptions)

        #[[[
        # Whether this unit has been executed already or not.
        # Useful for determining whether to re-execute
        # after a failed test is detected.
        #]]
        cpp_attr(CTExecutionUnit has_executed FALSE)

        #[[[
        # Whether the pass/fail status of this unit has been
        # printed yet. This ensures that parent units of
        # a failed unit are not printed multiple times.
        #]]
        cpp_attr(CTExecutionUnit has_printed FALSE)
        
        #[[[
        # Stores how many sections deep this execution unit is.
        # This is used to determine how many tabs to place in front
        # of the pass/fail print line.
        #]]
        cpp_attr(CTExecutionUnit section_depth 0)

	cpp_constructor(CTOR CTExecutionUnit str str bool)
	function("${CTOR}" self id test_id expect_fail)
                # Name could be a description or a function because it
                # isn't considered invalid to do so, such as using
                # a test name of "set"
                #
                # ID could be a desc or a function as well,
                # depending on whether the section/test function has
                # been initialized or not yet

		CTExecutionUnit(SET "${self}" test_id "${id}")
		CTExecutionUnit(SET "${self}" friendly_name "${test_id}")
		CTExecutionUnit(SET "${self}" expect_fail "${expect_fail}")
                cpp_map(CTOR section_names_map)
                CTExecutionUnit(SET "${self}" section_names_to_ids "${section_names_map}")
                cpp_map(CTOR children_map)
                CTExecutionUnit(SET "${self}" children "${children_map}")
	endfunction()

        #[[[
        # Add a new subsection to this unit.
        # The key must be the ID of the subsection
        # and the value must be a dereferenced pointer
        # pointing to the subsection.
        #
        # :param key: ID of the new subsection
        # :param child: Reference to the new subsection.
        #]]
        cpp_member(append_child CTExecutionUnit str CTExecutionUnit)
        function("${append_child}" self key child)
                #key could be desc or fxn
                cpp_get_global(_as_curr_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
                CTExecutionUnit(GET "${_as_curr_instance}" parent_name test_id)
                CTExecutionUnit(GET "${self}" test_id test_id)
                CTExecutionUnit(GET "${self}" children children)
                cpp_map(SET "${children}" "${key}" "${child}")
        endfunction()

        #[[[
        # Construct the list of all parents of this unit
        # from the root down to the immediate parent of this unit.
        # The returned list contains pointers to each of the
        # parents, ordered with the root as the last element.
        #
        # :param ret: A return variable that will be set to the
        #             constructed list.
        #]]
        cpp_member(get_parent_list CTExecutionUnit desc)
        function("${get_parent_list}" self ret)

            CTExecutionUnit(GET "${self}" next_parent parent)
            while(NOT next_parent STREQUAL "")
                CTExecutionUnit(GET "${next_parent}" parent_id test_id)
                list(APPEND ret_list "${next_parent}")
                CTExecutionUnit(GET "${next_parent}" next_parent parent)
            endwhile()
            set("${ret}" "${ret_list}" PARENT_SCOPE)

        endfunction()


	cpp_member(to_string CTExecutionUnit desc)
	function("${to_string}" self ret)
		CTExecutionUnit(GET "${self}" name friendly_name)
                CTExecutionUnit(GET "${self}" id test_id)
		CTExecutionUnit(GET "${self}" expect_fail expect_fail)
		CTExecutionUnit(GET "${self}" print_length print_length)
		CTExecutionUnit(GET "${self}" parent parent)
                #CTExecutionUnit(GET "${parent}" parent_map children)
		CTExecutionUnit(GET "${self}" children children)
                cpp_map(KEYS "${children}" children_keys)
		if(NOT parent STREQUAL "")
			#CTExecutionUnit(to_string "${parent}" parent_string)
		endif()

                foreach(child_key IN LISTS children_keys)
                    cpp_map(GET "${children}" child "${child_key}")
                    CTExecutionUnit(to_string "${child}" child_string)
                    set(children_repr "${children_repr}\n\
                        ${child_string}\n")

                endforeach()

		set("${ret}" "Name: $test_id, EXPECTFAIL:  ${expect_fail}, Print length: ${print_length}\n\
		Parent:\n\
			${parent}\n\
		Children:\n\
			${children_repr}" PARENT_SCOPE)
		#cpp_return("${ret}")
	endfunction()


	#[[[
	# Executes the test or section that this unit represents.
	# This function handles printing the pass/failure state
	# as well as executing subsections. However, if this unit
	# has already been executed, this function does nothing.
	#
	#]]
	cpp_member(execute CTExecutionUnit)
    function("${execute}" self)
		CTExecutionUnit(GET "${self}" _ex_expect_fail expect_fail)
        cpp_get_global(_ex_exec_expectfail "CT_EXEC_EXPECTFAIL")
		CTExecutionUnit(GET "${self}" _self_has_executed has_executed)
		if (_self_has_executed)
			return()
		endif()
		#Test has not yet been executed

		cpp_get_global(old_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
		cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${self}")

		if(_ex_expect_fail AND NOT _ex_exec_expectfail) #If this section expects to fail

            #We're in main interpreter so we need to configure and execute the subprocess
			ct_expectfail_subprocess("${self}")

		else()
			
			CTExecutionUnit(GET "${self}" id test_id)
			cpp_call_fxn("${id}")
		endif()
		cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${old_instance}")

        CTExecutionUnit(print_pass_or_fail "${self}")

        CTExecutionUnit(exec_sections "${self}")
                
        CTExecutionUnit(SET "${self}" has_executed TRUE)

	endfunction()


	#[[[
	# Executes all subsections of this unit.
	# If this unit has no subsections, this
	# function does nothing.
	#
	#]]
	cpp_member(exec_sections CTExecutionUnit)
        function("${exec_sections}" self)
        	CTExecutionUnit(GET "${self}" _es_expect_fail expect_fail)
        	cpp_get_global(_es_exec_expectfail "CT_EXEC_EXPECTFAIL")
        
        	# Get whether this section has subsections, only run again if subsections detected
		CTExecutionUnit(GET "${self}" _es_children_map children)
		cpp_map(KEYS "${_es_children_map}" _es_has_subsections)
		
		#If in main interpreter and not expecting to fail OR in subprocess
		if((NOT _es_has_subsections STREQUAL "") AND ((NOT _es_expect_fail AND NOT _es_exec_expectfail) OR (_es_exec_expectfail)))		
			cpp_get_global(old_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
        	        cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${self}")
        	        CTExecutionUnit(SET "${self}" execute_sections TRUE)
        	        CTExecutionUnit(GET "${self}" id test_id)
        	        cpp_call_fxn("${id}")
	                cpp_set_global("CT_CURRENT_EXECUTION_UNIT_INSTANCE" "${old_instance}")

		endif()

	endfunction()


	#[[[
	# Determines whether the unit passed or failed
	# and prints it, obeying the section depth,
	# print length, and whether colors are enabled.
	#
	#]]
	cpp_member(print_pass_or_fail CTExecutionUnit)
	function("${print_pass_or_fail}" self)
		CTExecutionUnit(GET "${self}" _ppof_expect_fail expect_fail)
		CTExecutionUnit(GET "${self}" _ppof_friendly_name friendly_name)
		CTExecutionUnit(GET "${self}" _ppof_exceptions exceptions)
		CTExecutionUnit(GET "${self}" _ppof_has_printed has_printed)
		CTExecutionUnit(GET "${self}" _ppof_print_length print_length)
		CTExecutionUnit(GET "${self}" _ppof_section_depth section_depth)
		
		cpp_get_global(_ppof_exec_expectfail "CT_EXEC_EXPECTFAIL")

		set(_ppof_test_fail "FALSE")

		if(_ppof_expect_fail AND _ppof_exec_expectfail)
			if(NOT "${_as_exceptions}" STREQUAL "")
	                    foreach(_as_exc IN LISTS _as_exceptions)
				message("${CT_BoldRed}Test named \"${_as_friendly_name}\" raised exception:")
				message("${_as_exc}${CT_ColorReset}")
                	    endforeach()
                	    set(_as_section_fail "TRUE")
	               endif()
		else()
			if(NOT ("${_ppof_exceptions}" STREQUAL ""))

				foreach(_ppof_exc IN LISTS _ppof_exceptions)
					message("${CT_BoldRed}Test named \"${_ppof_friendly_name}\" raised exception:")
					message("${_ppof_exc}${CT_ColorReset}")
				endforeach()

				#At least one test failed, so we will inform the caller that not all tests passed.
				cpp_set_global(CMAKETEST_TESTS_DID_PASS "FALSE")
				set(_ppof_test_fail "TRUE")
			endif()
		endif()


		if(_ppof_test_fail)
			if(NOT _ppof_has_printed)
				_ct_print_fail("${_ppof_friendly_name}" "${_ppof_section_depth}" "${_ppof_print_length}")
			endif()
		elseif(NOT _ppof_has_printed)
			_ct_print_pass("${_ppof_friendly_name}" "${_ppof_section_depth}" "${_ppof_print_length}")
		endif()

		CTExecutionUnit(SET "${self}" has_printed TRUE)

	endfunction()

cpp_end_class()
