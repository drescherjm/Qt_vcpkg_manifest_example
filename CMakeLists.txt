cmake_minimum_required(VERSION 3.21)

include(CMake/SupportSwitchingQtVersionAsAFeature.cmake)

project(vcpkg_qt_manifest_mode_example VERSION 1.0.0 DESCRIPTION "A sample project" LANGUAGES CXX)

set(LOCAL_PROJECT_NAME ${PROJECT_NAME})

# Enable C++17 or later
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CMake presets to use vcpkg toolchain file
# (or specify the toolchain manually when configuring)

# Find Qt via vcpkg if not found fail hard!
find_package(QT NAMES Qt5 Qt6 REQUIRED)

include(CMake/Qt56CoreMacros.cmake)

qt56_standard_project_setup()

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

qt56_add_executable(${LOCAL_PROJECT_NAME} main.cpp)

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

#include(CMake/HelperMacros.cmake)
#_get_all_cmake_targets( CMAKE_TARGETS ${CMAKE_SOURCE_DIR} )
#echo_targets( ${CMAKE_TARGETS} )

#include(CMake/DeployQtInstall.cmake)
#install_qt_runtime(${LOCAL_PROJECT_NAME})

include(CMake/InstallTargetRuntimeDependencies.cmake)

install(TARGETS ${LOCAL_PROJECT_NAME}
	RUNTIME_DEPENDENCY_SET MyDeps
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

add_executable_target_for_packaging( $<TARGET_FILE:${LOCAL_PROJECT_NAME}> )
install_runtime_dependencies_of_packaging_targets()

	if(MSVC)
		install(CODE "set(RUNTIME_LIBRARY_DESTINATION \"bin\")")
	else(MSVC)
		install(CODE "set (RUNTIME_LIBRARY_DESTINATION \"/usr/local/${PROJECT_NAME}/lib\")")
	endif(MSVC)

#install(IMPOR

    install(IMPORTED_RUNTIME_ARTIFACTS ${LOCAL_PROJECT_NAME}
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
        )

# install(RUNTIME_DEPENDENCY_SET MyDeps
        # PRE_EXCLUDE_REGEXES [=[Azure]=] [=[api-ms-]=] [=[ext-ms-]=] [[kernel32\\.dll]] 
        # POST_EXCLUDE_REGEXES [=[Azure]=] [=[.*system32\\/.*\\.dll]=] 
		# POST_INCLUDE_FILES AzureAttestManager.dll wpaxholder.dll PdmUtilities.dll AzureAttestNormal.dll
# )

install(CODE [[
	message(WARNING "Install prefix: ${CMAKE_INSTALL_PREFIX}")
	]]
)

#FILE(GLOB MY_INCLUDES_H "${PROJECT_SOURCE_DIR}/include/*.h")


# install(CODE [[ 
	# file( GLOB MY_SHARED_LIBRARIES "$<TARGET_FILE_DIR:vcpkg_qt_manifest_mode_example>/*.dll" ) 
	# message( WARNING MY_SHARED_LIBRARIES=${MY_SHARED_LIBRARIES})
	# ]]
# )

#include(CMake/SetupProjectPackaging.cmake)
