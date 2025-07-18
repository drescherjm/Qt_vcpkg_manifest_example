
# ─── Setup the qt.conf file! ─────────────────────────────

# Select the appropriate template based on the platform
if(WIN32 AND MSVC)
    set(QT_CONF_TEMPLATE ${CMAKE_CURRENT_SOURCE_DIR}/CMake/qt_msvc.conf.in)
elseif(UNIX)
    set(QT_CONF_TEMPLATE ${CMAKE_CURRENT_SOURCE_DIR}/CMake/qt_unix.conf.in)
else()
    message(WARNING "qt.conf generation not implemented for this platform")
    unset(QT_CONF_TEMPLATE)
endif()

# Configure and install if a template was selected
if(QT_CONF_TEMPLATE)
    set(QT_CONF_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/qt.conf")
    configure_file(${QT_CONF_TEMPLATE} ${QT_CONF_OUTPUT} @ONLY)

    # Install qt.conf next to the binary (usually bin)
    install(FILES "${QT_CONF_OUTPUT}" DESTINATION bin)
endif()


install(TARGETS ${LOCAL_PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

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
        DESTINATION "lib/platforms"
        FILES_MATCHING PATTERN "libq*.so"
    )

    # Imageformats plugin (optional but common)
    if(QT_VERSION_MAJOR EQUAL 6)
        get_target_property(QT_IMG_PLUGIN Qt6::QJpegPlugin LOCATION)
    else()
        get_target_property(QT_IMG_PLUGIN Qt5::QJpegPlugin LOCATION)
    endif()

    set(PLATFORM_DEPENDENCIES ${QT_IMG_PLUGIN} ${PLATFORM_DEPENDENCIES})

    get_filename_component(QT_IMG_PLUGIN_DIR "${QT_IMG_PLUGIN}" DIRECTORY)
    install(DIRECTORY "${QT_IMG_PLUGIN_DIR}/"
        DESTINATION "lib/imageformats"
        FILES_MATCHING PATTERN "libq*.so"
    )
endif()

install(CODE "set(PLATFORM_DEPENDENCIES \"${PLATFORM_DEPENDENCIES}\")")


if(MSVC)
    install(CODE "set(RUNTIME_LIBRARY_DESTINATION \"bin\")")
else(MSVC)
     install(CODE "set (RUNTIME_LIBRARY_DESTINATION \"/usr/local/${PROJECT_NAME}/lib\")")
endif(MSVC)

#SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib") # Dosen't work unless its set before the target's add_executable()

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
            DESTINATION ${RUNTIME_LIBRARY_DESTINATION}
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
  set(CMAKE_INSTALL_PREFIX /usr/local/${PROJECT_NAME})
  set(CPACK_PACKAGING_INSTALL_PREFIX /usr/local/${PROJECT_NAME})
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
