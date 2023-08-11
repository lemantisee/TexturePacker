cmake_minimum_required(VERSION 3.20)

cmake_policy(SET CMP0099 OLD) # Disable transitive link options
cmake_policy(SET CMP0118 NEW) # Increase GENERATED property scope
cmake_policy(SET CMP0117 NEW) # Don't add MSVC RTTI flag /GR
cmake_policy(SET CMP0111 NEW) # Fail during generation when imported target missing it's location
cmake_policy(SET CMP0095 NEW) # Properly escape RPATH entries
cmake_policy(SET CMP0092 NEW) # Don't add MSVC warning flag /W3 by default

project(TexturePacker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(BINDIR "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup()

qt_add_executable(${PROJECT_NAME}
    main.cpp
    ImageProvider.h ImageProvider.cpp
    res.qrc
    ImagePreview.qml
    FlatButton.qml
    Compressor.h Compressor.cpp
    BusyBar.qml
    FileDialogItem.h FileDialogItem.cpp
    ImageFilepath.h ImageFilepath.cpp
    StatusMessage.qml
)

qt_add_qml_module(${PROJECT_NAME}
    URI TexturePacker
    VERSION 1.0
    QML_FILES Main.qml ImagePreview.qml FlatButton.qml BusyBar.qml StatusMessage.qml
)

add_subdirectory(Ext)

set_target_properties(${PROJECT_NAME}
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${BINDIR}
    )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(${PROJECT_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTexturePacker
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::Widgets
    stb
    nvtt3
)
target_compile_options(${PROJECT_NAME} PUBLIC
    /permissive-    # standards conformance mode
    )

target_compile_definitions(${PROJECT_NAME} PUBLIC
    NOMINMAX
    UNICODE
    _UNICODE
    NDEBUG # disables C assertions
    )

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
