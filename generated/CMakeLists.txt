set(NAME generated_core)

set(sources
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/stm32f4xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/Core/Src/system_stm32f4xx.c

    ${CMAKE_CURRENT_SOURCE_DIR}/startup_stm32f411xe.s
)

add_library(${NAME} STATIC ${sources})
target_include_directories(${NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/Core/Inc)
target_link_libraries(${NAME} PRIVATE f4_drivers)

