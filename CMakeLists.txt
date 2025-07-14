cmake_minimum_required(VERSION 3.21)

project(TestProject0_WithQt6 LANGUAGES CXX)

# Enable C++17 or later
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CMake presets to use vcpkg toolchain file
# (or specify the toolchain manually when configuring)

# Find Qt via vcpkg if not found fail hard!
find_package(QT NAMES Qt5 Qt6 REQUIRED)

#Create a variable containing Qt5 or Qt6
set(QT Qt${QT_VERSION_MAJOR})

# We prepare lists of modules and libraries for different
# versions of Qt
set(APP_QT_MODULES Core Widgets)
set(APP_QT_TARGETS ${QT}::Core ${QT}::Widgets)

# Here everything is simple - find the modules we need.
find_package(${QT} REQUIRED ${APP_QT_MODULES})

set(LOCAL_PROJECT_NAME TestProject0_WithQt6)

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
