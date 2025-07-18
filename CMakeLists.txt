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

install(TARGETS ${LOCAL_PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

#install(CODE "
#    include(BundleUtilities)
#    message(STATUS BundleExecutable=\"${CMAKE_INSTALL_PREFIX}/bin/$<TARGET_FILE:${LOCAL_PROJECT_NAME}>\")
#    fixup_bundle(\"${CMAKE_INSTALL_PREFIX}/bin/vcpkg_qt_manifest_mode_example\" \"\"  \"\")
#    " COMPONENT Runtime
#)

include(InstallRequiredSystemLibraries)


set(PLATFORM_DEPENDENCIES)

if(UNIX AND NOT APPLE)
    # Platforms plugin
    if(QT_VERSION_MAJOR EQUAL 6)
        get_target_property(QT_PLAT_PLUGIN Qt6::QXcbIntegrationPlugin LOCATION)
    else()
        get_target_property(QT_PLAT_PLUGIN Qt5::QXcbIntegrationPlugin LOCATION)
    endif()

    set(PLATFORM_DEPENDENCIES ${QT_PLAT_PLUGIN} ${PLATFORM_DEPENDENCIES})

    get_filename_component(QT_PLAT_PLUGIN_DIR "${QT_PLAT_PLUGIN}" DIRECTORY)
    install(DIRECTORY "${QT_PLAT_PLUGIN_DIR}/"
        DESTINATION "lib/${CMAKE_PROJECT_NAME}/platforms"
        FILES_MATCHING PATTERN "libq*.so"
    )

    # Imageformats plugin (optional but common)
    if(QT_VERSION_MAJOR EQUAL 6)
        get_target_property(QT_IMG_PLUGIN Qt6::QJpegPlugin LOCATION)
    else()
        get_target_property(QT_IMG_PLUGIN Qt5::QJpegPlugin LOCATION)
    endif()
    get_filename_component(QT_IMG_PLUGIN_DIR "${QT_IMG_PLUGIN}" DIRECTORY)
    install(DIRECTORY "${QT_IMG_PLUGIN_DIR}/"
        DESTINATION "lib/${CMAKE_PROJECT_NAME}/imageformats"
        FILES_MATCHING PATTERN "libq*.so"
    )
endif()

install(CODE "set(PLATFORM_DEPENDENCIES \"${PLATFORM_DEPENDENCIES}\")")

message( STATUS PLATFORM_DEPENDENCIES=${PLATFORM_DEPENDENCIES} )
# Install runtime dependencies
install(CODE [[
    file(GET_RUNTIME_DEPENDENCIES
        LIBRARIES ${PLATFORM_DEPENDENCIES}
        EXECUTABLES "$<TARGET_FILE:vcpkg_qt_manifest_mode_example>"
        RESOLVED_DEPENDENCIES_VAR deps
        UNRESOLVED_DEPENDENCIES_VAR unresolved
    )

    foreach(dep IN LISTS deps)
        message( STATUS "Processing dependency: " ${dep})
        file(INSTALL
            DESTINATION /usr/local/lib
            TYPE SHARED_LIBRARY
            FOLLOW_SYMLINK_CHAIN
            FILES "${dep}"
        )
    endforeach()

    list(LENGTH unresolved unresolved_count)
    if(unresolved_count GREATER 0)
        message(FATAL_ERROR "Unresolved dependencies: ${unresolved}")
    endif()
]])


# ─── CPack packaging setup ───────────────────────────────

# Basic CPack settings
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_CONTACT "you@example.com")
set(CPACK_PACKAGE_VENDOR "Your Name or Company")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Example Qt app packaged via CPack")

if(WIN32)
  # NSIS installer on Windows
  set(CPACK_GENERATOR "NSIS")
  set(CPACK_NSIS_MODIFY_PATH ON)
  set(CPACK_NSIS_DISPLAY_NAME "${PROJECT_NAME} Installer")
  set(CPACK_NSIS_PACKAGE_NAME "${PROJECT_NAME}")
  #set(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\myapp.exe")
elseif(UNIX AND EXISTS "/etc/debian_version")
  # DEB package
  set(CMAKE_INSTALL_PREFIX /usr/local)
  set(CPACK_PACKAGING_INSTALL_PREFIX /usr/local)
  set(CPACK_GENERATOR "DEB")
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "you@example.com")
  set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.29)")
  set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
elseif(UNIX AND EXISTS "/etc/redhat-release")
  # RPM package
  set(CPACK_GENERATOR "RPM")
  set(CPACK_RPM_PACKAGE_LICENSE "MIT")
  set(CPACK_RPM_PACKAGE_RELEASE 1)
  set(CPACK_RPM_PACKAGE_GROUP "Applications/Utilities")
endif()

include(CPack)



