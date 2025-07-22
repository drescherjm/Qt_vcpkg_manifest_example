function(install_qt_runtime TARGET_NAME)
    # Where to install runtime files relative to install prefix
    set(QT_RUNTIME_DIR "bin")

    install(TARGETS ${TARGET_NAME}
        RUNTIME DESTINATION ${QT_RUNTIME_DIR}  # .exe on Windows
        BUNDLE DESTINATION .                   # .app on macOS
        LIBRARY DESTINATION lib
    )

    if(WIN32)
        find_program(WINDEPLOYQT_EXECUTABLE windeployqt REQUIRED)
		
		if (NOT EXISTS ${WINDEPLOYQT_EXECUTABLE}) 
			message(FATAL_ERROR WINDEPLOYQT_EXECUTABLE=${WINDEPLOYQT_EXECUTABLE})
		endif()
		
        install(CODE "
            message(STATUS \"Running windeployqt for ${TARGET_NAME}\")
            execute_process(COMMAND \"${WINDEPLOYQT_EXECUTABLE}\" \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${QT_RUNTIME_DIR}/$<TARGET_FILE_NAME:${TARGET_NAME}>\")
        ")

    elseif(APPLE)
        find_program(MACDEPLOYQT_EXECUTABLE macdeployqt REQUIRED)

        install(CODE "
            message(STATUS \"Running macdeployqt for ${TARGET_NAME}.app\")
            execute_process(COMMAND \"${MACDEPLOYQT_EXECUTABLE}\" \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${TARGET_NAME}.app\" -verbose=1)
        ")

    elseif(UNIX AND NOT APPLE)
        # Qt shared lib path
        if(Qt5Core_FOUND)
            get_target_property(QT_LIB_DIR Qt5::Core LOCATION)
        elseif(Qt6Core_FOUND)
            get_target_property(QT_LIB_DIR Qt6::Core LOCATION)
        else()
            message(FATAL_ERROR "Qt not found")
        endif()

        get_filename_component(QT_LIB_DIR "${QT_LIB_DIR}" DIRECTORY)
        set(QT_PLUGIN_DIR "${QT_LIB_DIR}/../plugins")

        # Install plugins
        install(DIRECTORY "${QT_PLUGIN_DIR}/platforms"
            DESTINATION "${QT_RUNTIME_DIR}"
            FILES_MATCHING PATTERN "*.so"
        )

        # Optional: qt.conf
        set(QT_CONF_CONTENT "[Paths]\nPlugins = platforms\n")
        file(WRITE "${CMAKE_BINARY_DIR}/qt.conf" "${QT_CONF_CONTENT}")
        install(FILES "${CMAKE_BINARY_DIR}/qt.conf"
                DESTINATION "${QT_RUNTIME_DIR}")
    endif()
endfunction()
