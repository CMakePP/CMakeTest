include_guard()


cpp_class(CTExecutionUnit)

	cpp_attr(CTExecutionUnit name)
	cpp_attr(CTExecutionUnit expect_fail)
	cpp_attr(CTExecutionUnit parent)
	cpp_attr(CTExecutionUnit children)

	cpp_constructor(CTOR CTExecutionUnit desc bool)
	function("${CTOR}" self name expect_fail)
		CTExecutionUnit(SET "${self}" name "${name}")
		CTExecutionUnit(SET "${self}" expect_fail "${expect_fail}")
	endfunction()

	cpp_member(to_string CTExecutionUnit desc)
	function("${to_string}" self ret)
		CTExecutionUnit(GET "${self}" name name)
		CTExecutionUnit(GET "${self}" expect_fail expect_fail)
		CTExecutionUnit(GET "${self}" parent parent)
		if(NOT parent STREQUAL "")
			CTExecutionUnit(to_string "${parent}" parent_string)
		endif()
		set("${ret}" "Name: ${name}, EXPECTFAIL:  ${expect_fail}\n\
		Parent:\n\
			${parent_string}
		" PARENT_SCOPE)
		#cpp_return("${ret}")
	endfunction()


cpp_end_class()
