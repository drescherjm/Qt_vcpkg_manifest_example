cmake_minimum_required(VERSION 3.21)

set(_LAST_QT_VERSION "${SELECT_QT_VERSION}")
get_property(_cached_LAST_QT_VERSION CACHE LAST_QT_VERSION PROPERTY VALUE)

set(SELECT_QT_VERSION "Qt6" CACHE STRING "Please select the Qt version.")
set_property(CACHE SELECT_QT_VERSION PROPERTY STRINGS "Qt5" "Qt6")

#With vcpkg features must be lowercase so we convert to qt5 and qt6 with the following:
string(TOLOWER "${SELECT_QT_VERSION}" VCPKG_FEATURE_NAME)

#Tell vcpkg the feature to use!
list(APPEND VCPKG_MANIFEST_FEATURES ${VCPKG_FEATURE_NAME})

MESSAGE(STATUS "Current=${SELECT_QT_VERSION} Last=${_LAST_QT_VERSION}")

if(DEFINED _cached_LAST_QT_VERSION AND NOT _LAST_QT_VERSION STREQUAL _cached_LAST_QT_VERSION)
    message(STATUS "Qt version has changed from '${_cached_LAST_QT_VERSION}' to '${_LAST_QT_VERSION}'")
   	#Clear any Qt* variables from the previous.
	get_cmake_property(_cacheVars CACHE_VARIABLES)
	foreach(_var ${_cacheVars})
		if(_var MATCHES "^Qt")
			message(STATUS "Unsetting cache variable: ${_var}")
			unset(${_var} CACHE)
		endif()
	endforeach()
endif()

set(LAST_QT_VERSION "${SELECT_QT_VERSION}" CACHE INTERNAL "Last configured value of SELECT_QT_VERSION")

project(vcpkg_qt_manifest_mode_example VERSION 1.0.0 DESCRIPTION "A sample project" LANGUAGES CXX)

set(LOCAL_PROJECT_NAME ${PROJECT_NAME})

# Enable C++17 or later
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CMake presets to use vcpkg toolchain file
# (or specify the toolchain manually when configuring)

# Find Qt via vcpkg if not found fail hard!
find_package(QT NAMES Qt5 Qt6 REQUIRED)

# The ability to support Qt5 or Qt6 is based on the following stackoverflow answer:
# https://stackoverflow.com/a/71131723/487892

#Create a variable containing Qt5 or Qt6
set(QT Qt${QT_VERSION_MAJOR})

# We prepare lists of modules and libraries for different
# versions of Qt
set(APP_QT_MODULES Core Widgets)
set(APP_QT_TARGETS ${QT}::Core ${QT}::Widgets)

# Here everything is simple - find the modules we need.
find_package(${QT} REQUIRED ${APP_QT_MODULES})

#if(UNIX)
#    set(CMAKE_VERBOSE_MAKEFILE ON)
#    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
#    set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
#    set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
#endif()

add_executable(${LOCAL_PROJECT_NAME} main.cpp)

target_link_libraries(${LOCAL_PROJECT_NAME} PRIVATE ${APP_QT_TARGETS})

# If using Qt's uic, moc, or rcc:
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# In Qt6 we need to run windeployqt to setup the platform plugin and other plugins since this 
# doesn't happen automatically yet. With Qt5 this is not needed so just run for Qt6.
if (QT_VERSION_MAJOR EQUAL 6)
	if (MSVC) 
		add_custom_command(TARGET ${LOCAL_PROJECT_NAME} POST_BUILD
			COMMAND ${QT}::windeployqt --no-compiler-runtime \"$<TARGET_FILE:${LOCAL_PROJECT_NAME}>\"
			COMMENT "Running windeployqt for $<CONFIG>"
		)
	endif()
endif()

include(CMake/SetupProjectPackaging.cmake)

