# Define a global property to store the list
set_property(GLOBAL PROPERTY _GLOBAL_LIST_OF_EXECUTABLE_TARGETS_FOR_INSTALL)

function(add_executable_target_for_packaging TARGET_NAME_PARAM)
	get_property(current_list GLOBAL PROPERTY _GLOBAL_LIST_OF_EXECUTABLE_TARGETS_FOR_INSTALL)

	list(FIND current_list "${TARGET_NAME_PARAM}" index)
    
	# If the element is not found (index is -1), append it
	if("${index}" EQUAL "-1")
		# Append the new item to the list
		list(APPEND current_list "${TARGET_NAME_PARAM}")
	
		# Set the updated list back to the global property
		set_property(GLOBAL PROPERTY _GLOBAL_LIST_OF_EXECUTABLE_TARGETS_FOR_INSTALL "${current_list}")
	endif()
	
endfunction()

function(install_runtime_dependencies_of_packaging_targets)
	
	get_property(current_list GLOBAL PROPERTY _GLOBAL_LIST_OF_EXECUTABLE_TARGETS_FOR_INSTALL)
	install(CODE "set(_GLOBAL_PACKAGING_TARGETS \"${current_list}\")")
	
	if(MSVC)
		install(CODE "set(RUNTIME_LIBRARY_DESTINATION \"bin\")")
	else(MSVC)
		install(CODE "set (RUNTIME_LIBRARY_DESTINATION \"/usr/local/${PROJECT_NAME}/lib\")")
	endif(MSVC)
	
	install(CODE [[
		file(GET_RUNTIME_DEPENDENCIES
			LIBRARIES ${PLATFORM_DEPENDENCIES}
			EXECUTABLES "${_GLOBAL_PACKAGING_TARGETS}"
			RESOLVED_DEPENDENCIES_VAR deps
			UNRESOLVED_DEPENDENCIES_VAR unresolved
			PRE_EXCLUDE_REGEXES "api-ms-" "ext-ms-" "kernel32\\.dll"
		)

		foreach(dep IN LISTS deps)
			message( STATUS "Processing dependency: " ${dep})
			file(INSTALL "${dep}"
				DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
				FOLLOW_SYMLINK_CHAIN
			)
		endforeach()

		list(LENGTH unresolved unresolved_count)
		if(unresolved_count GREATER 0)
			message(WARNING "Unresolved dependencies: ${unresolved}")
		endif()
	]])
endfunction()