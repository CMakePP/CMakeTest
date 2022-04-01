include_guard()


cpp_class(CTExecutionUnit)

	cpp_attr(CTExecutionUnit name)
	cpp_attr(CTExecutionUnit friendly_name)
	cpp_attr(CTExecutionUnit file)
	cpp_attr(CTExecutionUnit expect_fail)
	cpp_attr(CTExecutionUnit parent)
	cpp_attr(CTExecutionUnit children)
	cpp_attr(CTExecutionUnit print_length "${CT_PRINT_LENGTH}")
	cpp_attr(CTExecutionUnit print_length_forced FALSE)

	cpp_constructor(CTOR CTExecutionUnit desc desc bool)
	function("${CTOR}" self id name expect_fail)
		CTExecutionUnit(SET "${self}" name "${id}")
		CTExecutionUnit(SET "${self}" friendly_name "${name}")
		CTExecutionUnit(SET "${self}" expect_fail "${expect_fail}")
	endfunction()

        cpp_member(append_child CTExecutionUnit CTExecutionUnit)
        function("${append_child}" self child)
		CTExecutionUnit(GET "${self}" children children)
                list(APPEND children "${child}")
		CTExecutionUnit(SET "${self}" children "${children}")
        endfunction()

	cpp_member(to_string CTExecutionUnit desc)
	function("${to_string}" self ret)
		CTExecutionUnit(GET "${self}" name friendly_name)
		CTExecutionUnit(GET "${self}" expect_fail expect_fail)
		CTExecutionUnit(GET "${self}" print_length print_length)
		CTExecutionUnit(GET "${self}" parent parent)
		CTExecutionUnit(GET "${self}" children children)
		if(NOT parent STREQUAL "")
			CTExecutionUnit(to_string "${parent}" parent_string)
		endif()
		set("${ret}" "Name: ${name}, EXPECTFAIL:  ${expect_fail}, Print length: ${print_length}\n\
		Parent:\n\
			${parent_string}\n\
		Children:\n\
			${children}" PARENT_SCOPE)
		#cpp_return("${ret}")
	endfunction()


cpp_end_class()
