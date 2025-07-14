cmake_minimum_required(VERSION 3.21)

project(TestProject0_WithQt6 LANGUAGES CXX)

# Enable C++17 or later
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable CMake presets to use vcpkg toolchain file
# (or specify the toolchain manually when configuring)

# Find Qt6 via vcpkg
find_package(Qt6 REQUIRED COMPONENTS Widgets)

set(LOCAL_PROJECT_NAME TestProject0_WithQt6)

add_executable(${LOCAL_PROJECT_NAME} main.cpp)

target_link_libraries(${LOCAL_PROJECT_NAME} PRIVATE Qt6::Widgets)

# If using Qt's uic, moc, or rcc:
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

add_custom_command(TARGET ${LOCAL_PROJECT_NAME} POST_BUILD
    COMMAND Qt6::windeployqt --no-compiler-runtime \"$<TARGET_FILE:${LOCAL_PROJECT_NAME}>\"
    COMMENT "Running windeployqt for $<CONFIG>"
)
