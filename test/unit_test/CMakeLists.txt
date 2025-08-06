include(${CMAKE_SOURCE_DIR}/cmake/Helpers.cmake)

package_add_test(ExampleTest
        SOURCES
        ExampleTest.cpp
        DEPENDS
        ${PROJECT_NAME})