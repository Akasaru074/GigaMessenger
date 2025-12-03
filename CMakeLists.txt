cmake_minimum_required(VERSION 3.16)

project(GigaMessenger VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick QuickControls2 Network WebSockets)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appGigaMessenger
    main.cpp
)

qt_add_qml_module(appGigaMessenger
    URI GigaMessenger
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES messagemodel.h messagemodel.cpp
        SOURCES messagemodel.cpp messagemodel.h
        SOURCES messagemodel.cpp
        SOURCES websocketclient.h websocketclient.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appGigaMessenger PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appGigaMessenger
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGigaMessenger
    PRIVATE Qt6::Core
    PRIVATE Qt6::Gui
    PRIVATE Qt6::Quick
    PRIVATE Qt6::QuickControls2
    PRIVATE Qt6::Network
    PRIVATE Qt6::WebSockets
)

include(GNUInstallDirs)
install(TARGETS appGigaMessenger
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
