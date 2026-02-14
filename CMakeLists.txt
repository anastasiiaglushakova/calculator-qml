cmake_minimum_required(VERSION 3.16)
project(calculator-qml VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 5.12 REQUIRED COMPONENTS Core Gui Quick)

add_executable(calculator-qml
    main.cpp
    calculator.qrc
)

target_link_libraries(calculator-qml PRIVATE
    Qt5::Core
    Qt5::Gui
    Qt5::Quick
)

set_target_properties(calculator-qml PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)