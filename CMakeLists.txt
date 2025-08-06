cmake_minimum_required(VERSION 3.20)

include(FetchContent)
if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
    cmake_policy(SET CMP0135 NEW)
endif()

# Add project_options from https://github.com/aminya/project_options
# Change the version in the following URL to update the package (watch the releases of the repository for future updates)
set(PROJECT_OPTIONS_VERSION "v0.41.0")
FetchContent_Declare(
        _project_options
        URL https://github.com/aminya/project_options/archive/refs/tags/${PROJECT_OPTIONS_VERSION}.zip)
FetchContent_MakeAvailable(_project_options)
include(${_project_options_SOURCE_DIR}/Index.cmake)

run_conan(
        HOST_PROFILE default auto-cmake
        BUILD_PROFILE default
        INSTALL_ARGS --build=missing
)

find_package(Python 3.8 COMPONENTS Interpreter Development.Module REQUIRED)
set(PYBIND11_FINDPYTHON ON)
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_CUDA_ARCHITECTURES 89)
set(CMAKE_CUDA_COMPILER /usr/local/cuda/bin/nvcc)


project(knet VERSION 0.0.1 DESCRIPTION "Neural Network library" LANGUAGES CXX C CUDA)

set(CMAKE_CXX_STANDARD 23)

set(ENABLE_CLANG_TIDY "ENABLE_CLANG_TIDY")
set(ENABLE_CPPCHECK "ENABLE_CPPCHECK")

project_options(
        PREFIX "knet"
        ENABLE_CACHE
        ${ENABLE_CPPCHECK}
        ${ENABLE_CLANG_TIDY}
         WARNINGS_AS_ERRORS
)

include(${CMAKE_SOURCE_DIR}/cmake/Helpers.cmake)

add_library_and_link(NAME ${PROJECT_NAME}
        SOURCES
        src/Example.cpp
)

add_app(${PROJECT_NAME}_app
        SOURCES
        src/main.cpp
        DEPENDS
        ${PROJECT_NAME}
)
pybind11_add_module(testpackage ${CMAKE_SOURCE_DIR}/bindings/test.cpp)

if(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
    message(STATUS "Testing enabled")
    enable_testing()
    include(GoogleTest)
    add_subdirectory(test)
endif ()