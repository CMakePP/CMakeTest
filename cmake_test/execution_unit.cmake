include_guard()

include(cpp/cpp)

cpp_class(CTExecutionUnit)

	cpp_attr(CTExecutionUnit name)
	cpp_attr(CTExecutionUnit friendly_name)
	cpp_attr(CTExecutionUnit file)
	cpp_attr(CTExecutionUnit expect_fail)
	cpp_attr(CTExecutionUnit parent)
	cpp_attr(CTExecutionUnit children)
	cpp_attr(CTExecutionUnit print_length "${CT_PRINT_LENGTH}")
	cpp_attr(CTExecutionUnit print_length_forced FALSE)
        cpp_attr(CTExecutionUnit execute_sections FALSE)
        cpp_attr(CTExecutionUnit section_names_to_ids)


	cpp_constructor(CTOR CTExecutionUnit desc desc bool)
	function("${CTOR}" self id name expect_fail)
		CTExecutionUnit(SET "${self}" name "${id}")
		CTExecutionUnit(SET "${self}" friendly_name "${name}")
		CTExecutionUnit(SET "${self}" expect_fail "${expect_fail}")
                cpp_map(CTOR section_names_map)
                CTExecutionUnit(SET "${self}" section_names_to_ids "${section_names_map}")
                cpp_map(CTOR children_map)
                CTExecutionUnit(SET "${self}" children "${children_map}")
	endfunction()

        cpp_member(append_child CTExecutionUnit desc CTExecutionUnit)
        function("${append_child}" self key child)
                cpp_get_global(_as_curr_instance "CT_CURRENT_EXECUTION_UNIT_INSTANCE")
                CTExecutionUnit(GET "${_as_curr_instance}" parent_name name)
                CTExecutionUnit(GET "${self}" name name)
		CTExecutionUnit(GET "${self}" children children)
                cpp_map(SET "${children}" "${key}" "${child}")
        endfunction()

        cpp_member(get_parent_list CTExecutionUnit desc)
        function("${get_parent_list}" self ret)

            CTExecutionUnit(GET "${self}" next_parent parent)
            while(NOT next_parent STREQUAL "")
                CTExecutionUnit(GET "${next_parent}" parent_id name)
                list(APPEND ret_list "${next_parent}")
                CTExecutionUnit(GET "${next_parent}" next_parent parent)
            endwhile()
            set("${ret}" "${ret_list}" PARENT_SCOPE)

        endfunction()


	cpp_member(to_string CTExecutionUnit desc)
	function("${to_string}" self ret)
		CTExecutionUnit(GET "${self}" name friendly_name)
                CTExecutionUnit(GET "${self}" id name)
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

		set("${ret}" "Name: ${name}, EXPECTFAIL:  ${expect_fail}, Print length: ${print_length}\n\
		Parent:\n\
			${parent}\n\
		Children:\n\
			${children_repr}" PARENT_SCOPE)
		#cpp_return("${ret}")
	endfunction()


cpp_end_class()
