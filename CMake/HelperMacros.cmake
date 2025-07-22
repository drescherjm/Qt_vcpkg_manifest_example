#########################################################################################
#
#	This module contains a few Helper Macros that add case insensitive list operations
#	among other functionality.
#
#########################################################################################

function (_get_all_cmake_targets out_var current_dir)
    get_property(targets DIRECTORY ${current_dir} PROPERTY BUILDSYSTEM_TARGETS)
	get_property(importTargets DIRECTORY ${current_dir} PROPERTY IMPORTED_TARGETS)
	get_property(subdirs DIRECTORY ${current_dir} PROPERTY SUBDIRECTORIES)
	
	list(APPEND targets	${importTargets})

    foreach(subdir ${subdirs})
        _get_all_cmake_targets(subdir_targets ${subdir})
        list(APPEND targets ${subdir_targets})
		get_property(importTargets DIRECTORY ${subdir} PROPERTY IMPORTED_TARGETS)
		list(APPEND targets ${importTargets})
    endforeach()

    set(${out_var} ${targets} PARENT_SCOPE)
endfunction()

# One way to use this is:
# _get_all_cmake_targets( CMAKE_TARGETS ${CMAKE_SOURCE_DIR} )
# echo_targets( ${CMAKE_TARGETS} )


#########################################################################################
# The print_properties ... macros were taken from the following StackOverflow post:
# https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake
#
#########################################################################################

function(print_properties)
    message ("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction(print_properties)

function(print_whitelisted_properties)
    message ("CMAKE_WHITELISTED_PROPERTY_LIST = ${CMAKE_WHITELISTED_PROPERTY_LIST}")
endfunction(print_whitelisted_properties)

# This useful script was taken from http://www.kitware.com/blog/home/post/390 and slightly modified.
function(echo_target_property tgt prop)
  # message("echo_target_property -- tgt = ${tgt}, prop = ${prop}")
  # v for value, d for defined, s for set
  get_property(v TARGET ${tgt} PROPERTY ${prop})
  get_property(d TARGET ${tgt} PROPERTY ${prop} DEFINED)
  get_property(s TARGET ${tgt} PROPERTY ${prop} SET)
 
  # only produce output for values that are set
  if(s)
    message("tgt='${tgt}' prop='${prop}'")
    message("  value='${v}'")
    message("  defined='${d}'")
    message("  set='${s}'")
    message("")
  endif()
endfunction()
 
function(echo_target tgt)
  if(NOT TARGET ${tgt})
    message("There is no target named '${tgt}'")
    return()
  endif()
 
  set(props
    DEBUG_OUTPUT_NAME
    DEBUG_POSTFIX
    RELEASE_OUTPUT_NAME
    RELEASE_POSTFIX
    ARCHIVE_OUTPUT_DIRECTORY
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE
    ARCHIVE_OUTPUT_NAME
    ARCHIVE_OUTPUT_NAME_DEBUG
    ARCHIVE_OUTPUT_NAME_RELEASE
    AUTOMOC
    AUTOMOC_MOC_OPTIONS
    BUILD_WITH_INSTALL_RPATH
    BUNDLE
    BUNDLE_EXTENSION
    COMPILE_DEFINITIONS
    COMPILE_DEFINITIONS_DEBUG
    COMPILE_DEFINITIONS_RELEASE
    COMPILE_FLAGS
    COMPILE_OPTIONS
    DEBUG_POSTFIX
    RELEASE_POSTFIX
    DEFINE_SYMBOL
    ENABLE_EXPORTS
    EXCLUDE_FROM_ALL
    EchoString
    FOLDER
    FRAMEWORK
    Fortran_FORMAT
    Fortran_MODULE_DIRECTORY
    GENERATOR_FILE_NAME
    GNUtoMS
    HAS_CXX
    IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
    IMPORTED
    IMPORTED_CONFIGURATIONS
    IMPORTED_IMPLIB
    IMPORTED_IMPLIB_DEBUG
    IMPORTED_IMPLIB_RELEASE
    IMPORTED_LINK_DEPENDENT_LIBRARIES
    IMPORTED_LINK_DEPENDENT_LIBRARIES_DEBUG
    IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE
    IMPORTED_LINK_INTERFACE_LANGUAGES
    IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG
    IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE
    IMPORTED_LINK_INTERFACE_LIBRARIES
    IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG
    IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE
    IMPORTED_LINK_INTERFACE_MULTIPLICITY
    IMPORTED_LINK_INTERFACE_MULTIPLICITY_DEBUG
    IMPORTED_LINK_INTERFACE_MULTIPLICITY_RELEASE
    IMPORTED_LOCATION
    IMPORTED_LOCATION_DEBUG
    IMPORTED_LOCATION_RELEASE
    IMPORTED_NO_SONAME
    IMPORTED_NO_SONAME_DEBUG
    IMPORTED_NO_SONAME_RELEASE
    IMPORTED_SONAME
    IMPORTED_SONAME_DEBUG
    IMPORTED_SONAME_RELEASE
    IMPORT_PREFIX
    IMPORT_SUFFIX
    INCLUDE_DIRECTORIES
    INSTALL_NAME_DIR
    INSTALL_RPATH
    INSTALL_RPATH_USE_LINK_PATH
    INTERFACE_COMPILE_DEFINITIONS
    INTERFACE_COMPILE_OPTIONS
    INTERFACE_INCLUDE_DIRECTORIES
    INTERFACE_LINK_LIBRARIES
    INTERPROCEDURAL_OPTIMIZATION
    INTERPROCEDURAL_OPTIMIZATION_DEBUG
    INTERPROCEDURAL_OPTIMIZATION_RELEASE
    LABELS
    LIBRARY_OUTPUT_DIRECTORY
    LIBRARY_OUTPUT_DIRECTORY_DEBUG
    LIBRARY_OUTPUT_DIRECTORY_RELEASE
    LIBRARY_OUTPUT_NAME
    LIBRARY_OUTPUT_NAME_DEBUG
    LIBRARY_OUTPUT_NAME_RELEASE
    LINKER_LANGUAGE
    LINK_DEPENDS
    LINK_FLAGS
    LINK_FLAGS_DEBUG
    LINK_FLAGS_RELEASE
    LINK_INTERFACE_LIBRARIES
    LINK_INTERFACE_LIBRARIES_DEBUG
    LINK_INTERFACE_LIBRARIES_RELEASE
    LINK_INTERFACE_MULTIPLICITY
    LINK_INTERFACE_MULTIPLICITY_DEBUG
    LINK_INTERFACE_MULTIPLICITY_RELEASE
    LINK_LIBRARIES
    LINK_SEARCH_END_STATIC
    LINK_SEARCH_START_STATIC
    # LOCATION
    # LOCATION_DEBUG
    # LOCATION_RELEASE
    MACOSX_BUNDLE
    MACOSX_BUNDLE_INFO_PLIST
    MACOSX_FRAMEWORK_INFO_PLIST
    MAP_IMPORTED_CONFIG_DEBUG
    MAP_IMPORTED_CONFIG_RELEASE
    OSX_ARCHITECTURES
    OSX_ARCHITECTURES_DEBUG
    OSX_ARCHITECTURES_RELEASE
    OUTPUT_NAME
    OUTPUT_NAME_DEBUG
    OUTPUT_NAME_RELEASE
    POST_INSTALL_SCRIPT
    PREFIX
    PRE_INSTALL_SCRIPT
    PRIVATE_HEADER
    PROJECT_LABEL
    PUBLIC_HEADER
    RESOURCE
    RULE_LAUNCH_COMPILE
    RULE_LAUNCH_CUSTOM
    RULE_LAUNCH_LINK
    RUNTIME_OUTPUT_DIRECTORY
    RUNTIME_OUTPUT_DIRECTORY_DEBUG
    RUNTIME_OUTPUT_DIRECTORY_RELEASE
    RUNTIME_OUTPUT_NAME
    RUNTIME_OUTPUT_NAME_DEBUG
    RUNTIME_OUTPUT_NAME_RELEASE
    SKIP_BUILD_RPATH
    SOURCES
    SOVERSION
    STATIC_LIBRARY_FLAGS
    STATIC_LIBRARY_FLAGS_DEBUG
    STATIC_LIBRARY_FLAGS_RELEASE
    SUFFIX
    TYPE
    VERSION
    VS_DOTNET_REFERENCES
    VS_GLOBAL_WHATEVER
    VS_GLOBAL_KEYWORD
    VS_GLOBAL_PROJECT_TYPES
    VS_KEYWORD
    VS_SCC_AUXPATH
    VS_SCC_LOCALPATH
    VS_SCC_PROJECTNAME
    VS_SCC_PROVIDER
    VS_WINRT_EXTENSIONS
    VS_WINRT_REFERENCES
    WIN32_EXECUTABLE
    XCODE_ATTRIBUTE_WHATEVER
  )
 
  message("======================== ${tgt} ========================")
  foreach(p ${props})
    echo_target_property("${tgt}" "${p}")
  endforeach()
  message("")
endfunction()
 
 
function(echo_targets)
  set(tgts ${ARGV})
  foreach(t ${tgts})
    echo_target("${t}")
  endforeach()
endfunction()

function(print_target_properties tgt)
    if ("${CMAKE_PROPERTY_LIST}" STREQUAL "") 
		# Get all propreties that cmake supports
		execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

		# Convert command output into a CMake list
		STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
		STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
		# Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
		list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$")
		# For some reason, "TYPE" shows up twice - others might too?
		list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)

		# build whitelist by filtering down from CMAKE_PROPERTY_LIST in case cmake is
		# a different version, and one of our hardcoded whitelisted properties
		# doesn't exist!
		unset(CMAKE_WHITELISTED_PROPERTY_LIST)
		foreach(prop ${CMAKE_PROPERTY_LIST})
			if(prop MATCHES "^(INTERFACE|[_a-z]|IMPORTED_LIBNAME_|MAP_IMPORTED_CONFIG_)|^(COMPATIBLE_INTERFACE_(BOOL|NUMBER_MAX|NUMBER_MIN|STRING)|EXPORT_NAME|IMPORTED(_GLOBAL|_CONFIGURATIONS|_LIBNAME)?|NAME|TYPE|NO_SYSTEM_FROM_IMPORTED)$")
				list(APPEND CMAKE_WHITELISTED_PROPERTY_LIST ${prop})
			endif()
		endforeach(prop)
	endif()

    if(NOT TARGET ${tgt})
      message("There is no target named '${tgt}'")
      return()
    endif()

    get_target_property(target_type ${tgt} TYPE)
    if(target_type STREQUAL "INTERFACE_LIBRARY")
        set(PROP_LIST ${CMAKE_WHITELISTED_PROPERTY_LIST})
    else()
        set(PROP_LIST ${CMAKE_PROPERTY_LIST})
    endif()

    foreach (prop ${PROP_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        # message ("Checking ${prop}")
        get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
        if (propval)
            get_target_property(propval ${tgt} ${prop})
            message ("${tgt} ${prop} = ${propval}")
        endif()
    endforeach(prop)
endfunction(print_target_properties)

#########################################################################################

MACRO(LIST_CONTAINS var value)
  SET(${var})
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} TRUE)
	  break()
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_CONTAINS)

#########################################################################################

MACRO(LIST_CONTAINS_IGNORE_CASE var value)
  SET(${var})
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} TRUE)
	ELSE(${value} STREQUAL ${value2})
		STRING( TOUPPER ${value} UpcaseValue )
		STRING( TOUPPER ${value2} UpcaseValue2 )
		 if (${UpcaseValue} STREQUAL ${UpcaseValue2})
			set(${var} TRUE)
			break()
		 endif (${UpcaseValue} STREQUAL ${UpcaseValue2})
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_CONTAINS_IGNORE_CASE)

#########################################################################################
# Returns ${value}-NOTFOUND if not found or the matched string in the same case as the 
# list

MACRO(LIST_FIND_IGNORE_CASE var value)
  SET(${var} "${value}-NOTFOUND")
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} ${value2})
	  break()
	ELSE(${value} STREQUAL ${value2})
		STRING( TOUPPER ${value} UpcaseValue )
		STRING( TOUPPER ${value2} UpcaseValue2 )
		 if (${UpcaseValue} STREQUAL ${UpcaseValue2})
			set(${var} ${value2})
			break()
		 endif (${UpcaseValue} STREQUAL ${UpcaseValue2})
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_FIND_IGNORE_CASE)

#########################################################################################

MACRO(LIST_FIND var value)
  SET(${var} "${value}-NOTFOUND")
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} ${value2})
	  break()
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_FIND)

#########################################################################################

macro(LIST_TO_CSV_STRING my_string)
	unset( ___TEMP___ )
	FOREACH (value2 ${ARGN})
		if (___TEMP___)
			set ( ___TEMP___ ${___TEMP___} "," ${value2} )
		else(___TEMP___)
			set ( ___TEMP___ ${value2} )
		endif(___TEMP___)
	ENDFOREACH (value2) 
	set( ${my_string} "${___TEMP___}" )
	unset( ___TEMP___ )
endmacro(LIST_TO_CSV_STRING)

#########################################################################################

macro( print_list my_message)
	unset(__LIST_OUTPUT__)
	LIST_TO_CSV_STRING( __LIST_OUTPUT__ ${ARGN} )
	MESSAGE( STATUS "${my_message} " ${__LIST_OUTPUT__})
	unset(__LIST_OUTPUT__)
endmacro( print_list )

#########################################################################################

macro( conditional_define VariableName DefineName)
	if (${VariableName})
	
		message( STATUS "add_definitions(-D${DefineName})" )
		add_definitions(-D${DefineName})
		
	endif(${VariableName})
endmacro( conditional_define )

#########################################################################################

macro( conditional_not_define VariableName DefineName)
	if (NOT ${VariableName})
	
		message( STATUS "add_definitions(-D${DefineName})" )
		add_definitions(-D${DefineName})
		
	endif(NOT ${VariableName})
endmacro( conditional_not_define )

#########################################################################################

function( define_from_environment VariableName PackageName)
	if (NOT DEFINED ${VariableName})
		message( STATUS "${VariableName}=$ENV{${VariableName}}" )
		if (NOT "$ENV{${VariableName}}" STREQUAL "")
			set(${VariableName} $ENV{${VariableName}} CACHE PATH "Set the path for ${PackageName}" FORCE)
		endif (NOT "$ENV{${VariableName}}" STREQUAL "")
	endif(NOT DEFINED ${VariableName})
endfunction( define_from_environment)

#########################################################################################

macro( myproject ProjectName )
	set( LOCAL_PROJECT_NAME ${ProjectName})
	set( LOCAL_PROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
	set( LOCAL_PROJECT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

	set (${LOCAL_PROJECT_NAME}_VERSION_MAJOR ${${PROJECT_NAME}_VERSION_MAJOR})
	set (${LOCAL_PROJECT_NAME}_VERSION_MINOR ${${PROJECT_NAME}_VERSION_MINOR})
	set (${LOCAL_PROJECT_NAME}_VERSION_PATCH ${${PROJECT_NAME}_VERSION_PATCH_CLEAN})
	set (${LOCAL_PROJECT_NAME}_VERSION_STRING "${${LOCAL_PROJECT_NAME}_VERSION_MAJOR}.${${LOCAL_PROJECT_NAME}_VERSION_MINOR}.${${LOCAL_PROJECT_NAME}_VERSION_PATCH}")

	#RESET_OPTIMIZATIONS()
	initialize_project(${LOCAL_PROJECT_NAME})
	
endmacro( myproject )

#########################################################################################

macro( mysubproject ProjectName )
	set( LOCAL_SUBPROJECT_NAME ${ProjectName})
	set( LOCAL_SUBPROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
	set( LOCAL_SUBPROJECT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})			
endmacro( mysubproject )

#########################################################################################

macro(create_string_from_list my_str)
 foreach(VALUE ${ARGN})
  if ("${VALUE}" STREQUAL "${ARGV1}")
   set(result "${VALUE}")
  else()
   set(result "${result} ${VALUE}")
  endif()
 endforeach(VALUE)
 set(${my_str} ${result})
endmacro(create_string_from_list) 

#########################################################################################

macro(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
        SET(dirlist ${dirlist} ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
endmacro()

#########################################################################################

macro ( setup_library_source_groups )
		
	set (extra_macro_args ${ARGN})
	list(LENGTH extra_macro_args num_extra_args)
	if (${num_extra_args} GREATER 0)
		
		#SOURCE_GROUP("${ARGV0}\\CMake Rules" REGULAR_EXPRESSION "\\.rule$")
		
		SOURCE_GROUP("${ARGV0}\\Generated" FILES
			  ${${LOCAL_PROJECT_NAME}_RC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_MOC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_UI_HDRS}
		)
		
		SOURCE_GROUP("${ARGV0}\\Source Files" FILES
			 ${${LOCAL_PROJECT_NAME}_SRCS}
		)
			
		SOURCE_GROUP("${ARGV0}\\Header Files" FILES
			 ${${LOCAL_PROJECT_NAME}_EXT_HDRS}
			 ${${LOCAL_PROJECT_NAME}_MOC_HDRS}
		)
		
		SOURCE_GROUP("${ARGV0}\\Resources" FILES
			  ${${LOCAL_PROJECT_NAME}_UIS}
			  ${${LOCAL_PROJECT_NAME}_RCS}
		)
	else()
	
		#SOURCE_GROUP("CMake Rules" REGULAR_EXPRESSION "\\.rule$")
	
		SOURCE_GROUP("Generated" FILES
			  ${${LOCAL_PROJECT_NAME}_RC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_MOC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_UI_HDRS}
		)

		SOURCE_GROUP("Resources" FILES
			  ${${LOCAL_PROJECT_NAME}_UIS}
			  ${${LOCAL_PROJECT_NAME}_RCS}
		)
		
	endif()
	
endmacro ( setup_library_source_groups )

#########################################################################################

macro( add_library_module ModuleListName ModuleName )
	get_property(is_defined GLOBAL PROPERTY ${ModuleListName} DEFINED)
	if(NOT is_defined)
		define_property(GLOBAL PROPERTY ${ModuleListName} 
			BRIEF_DOCS "List of library modules"
			FULL_DOCS "List of library modules")
	endif()
	set_property(GLOBAL APPEND PROPERTY ${ModuleListName} "${ModuleName}")	
endmacro( add_library_module )

#########################################################################################

macro(init_lib_shared_static_option shared)
option (BUILD_${LOCAL_PROJECT_NAME}_SHARED		"Build ${LOCAL_PROJECT_NAME} as a shared library" ${shared})

if (BUILD_${LOCAL_PROJECT_NAME}_SHARED)
	set(${LOCAL_PROJECT_NAME}_SHARED SHARED)
else (BUILD_${LOCAL_PROJECT_NAME}_SHARED)
	set(${LOCAL_PROJECT_NAME}_SHARED)
endif (BUILD_${LOCAL_PROJECT_NAME}_SHARED)

endmacro(init_lib_shared_static_option)

#########################################################################################

# VERSION_STR_TO_INTS Macro
# This macro converts a version string into its three integer components.
#
# Usage:
#     VERSION_STR_TO_INTS( major minor patch version )
#
# Parameters:
#     major      The variable to store the major integer component in.
#     minor      The variable to store the minor integer component in.
#     patch      The variable to store the patch integer component in.
#     version    The version string to convert ("#.#.#" format).
macro( VERSION_STR_TO_INTS major minor patch version )

    string( REGEX REPLACE "([0-9]+).[0-9]+.[0-9]+" "\\1" ${major} ${version} )
    string( REGEX REPLACE "[0-9]+.([0-9]+).[0-9]+" "\\1" ${minor} ${version} )
    string( REGEX REPLACE "[0-9]+.[0-9]+.([0-9]+)" "\\1" ${patch} ${version} )

endmacro( VERSION_STR_TO_INTS )

#########################################################################################

macro( dump_all_variables )

	get_cmake_property(_variableNames VARIABLES)
	foreach (_variableName ${_variableNames})
		message(STATUS "${_variableName}=${${_variableName}}")
	endforeach()

endmacro( dump_all_variables )

#########################################################################################

macro( dump_all_variables_starting_with Name )

	get_cmake_property(_variableNames VARIABLES)
	foreach (_variableName ${_variableNames})
		if ( _variableName MATCHES ^${Name}* )
			message(STATUS "${_variableName}=${${_variableName}}")
		endif()
	endforeach()

endmacro( dump_all_variables_starting_with )

#########################################################################################
