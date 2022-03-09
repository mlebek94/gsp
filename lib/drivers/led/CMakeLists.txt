set(NAME led)

add_library(${NAME} STATIC)
target_sources(${NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/led.cpp)
target_include_directories(${NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/)
target_link_libraries(${NAME} PRIVATE f4_drivers)
