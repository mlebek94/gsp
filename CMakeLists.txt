cmake_minimum_required(VERSION 3.10)

project(guitar-signal-processor VERSION 0.0.1 LANGUAGES CXX C ASM)

include(${CMAKE_CURRENT_SOURCE_DIR}/toolchain/arm-none-eabi-gcc.cmake)

set(BOARD STM32F411E-DISCO)

add_subdirectory(vendor)
add_subdirectory(lib)
add_subdirectory(app)

set(OUT ${PROJECT_NAME}.out)

add_executable(${OUT} )

target_sources(${OUT} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/system_stm32f4xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/startup_stm32f411xe.s
)

target_include_directories(${OUT} PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Inc
)

target_link_libraries(${OUT} PRIVATE f4_drivers led)

target_link_options(${OUT} PRIVATE
    -T${CMAKE_SOURCE_DIR}/generated/STM32F411VETx_FLASH.ld
    -Wl,-Map=${CMAKE_CURRENT_SOURCE_DIR}/build/${PROJECT_NAME}.map,--cref
)


# Print OUT size
add_custom_command(TARGET ${OUT}
        POST_BUILD
        COMMAND arm-none-eabi-size ${OUT})

# Create hex file
add_custom_command(TARGET ${OUT}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${OUT} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${OUT} ${PROJECT_NAME}.bin)