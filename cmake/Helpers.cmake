function(add_app APP_NAME)
    cmake_parse_arguments(ARGS "" "" "SOURCES;DEPENDS" ${ARGN})
    add_executable(${APP_NAME} ${ARGS_SOURCES})
    get_property(PROJECT_LIBS GLOBAL PROPERTY PROJECT_LIBS_PROPERTY)
    target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
    find_and_link_libs(${APP_NAME} DEPENDS ${ARGS_DEPENDS})
endfunction()

function(package_add_test TESTNAME)
    cmake_parse_arguments(ARGS "${options}" "" "SOURCES;DEPENDS" ${ARGN})
    add_executable(${TESTNAME} ${ARGS_SOURCES})
    target_include_directories(${TESTNAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)
    find_and_link_test_libs(${TESTNAME})
    gtest_discover_tests(${TESTNAME}
            WORKING_DIRECTORY ${PROJECT_DIR}
            PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_DIR}"
    )
endfunction()

function(add_library_and_link)
    set(prefix ARG)
    set(options SKIP_CXX_FLAGS)
    set(singleValues NAME)
    set(multiValues SOURCES DEPENDS)
    cmake_parse_arguments(${prefix} "${options}" "${singleValues}" "${multiValues}" ${ARGN})
    if (ARG_SKIP_CXX_FLAGS)
        set(SKIP_CXX_FLAGS "SKIP_CXX_FLAGS")
    endif ()

    set(LIB_NAME ${${prefix}_NAME})
    set(LIB_SOURCES ${${prefix}_SOURCES})
    add_library(${LIB_NAME} STATIC ${LIB_SOURCES})

    find_and_link_libs(${LIB_NAME} DEPENDS ${${prefix}_DEPENDS})
endfunction()

function(find_and_link_libs TARGET_NAME)
    cmake_parse_arguments(ARGS "" "" "DEPENDS" ${ARGN})
    target_include_directories(${TARGET_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/include)
    target_find_dependencies(${TARGET_NAME}
            PRIVATE_CONFIG
            fmt
            spdlog
            pybind11
    )

    target_link_system_libraries(${TARGET_NAME}
            PRIVATE
            fmt::fmt
            spdlog::spdlog

    )

    target_link_libraries(${TARGET_NAME}
            PRIVATE knet_project_options knet_project_warnings
            PUBLIC
            pybind11::headers
            ${ARGS_DEPENDS}
    )
endfunction()

function(find_and_link_test_libs TARGET_NAME)
    target_find_dependencies(${TARGET_NAME}
            PRIVATE_CONFIG
            fmt
            spdlog
            pybind11
            GTest
    )

    target_link_system_libraries(${TARGET_NAME}
            PRIVATE
            fmt::fmt
            spdlog::spdlog
            gtest::gtest
    )
    target_link_libraries(${TARGET_NAME}
            PRIVATE knet_project_options knet_project_warnings
            PUBLIC
            pybind11::headers
            ${ARGS_DEPENDS}
    )

endfunction()