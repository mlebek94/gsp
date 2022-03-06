cmake_minimum_required(VERSION 3.10)

project(guitar-signal-processor VERSION 0.0.1 LANGUAGES CXX C ASM)

include(${CMAKE_CURRENT_SOURCE_DIR}/toolchain/arm-none-eabi-g++.cmake)

set(BOARD STM32F411E-DISCO)

add_subdirectory(vendor)
add_subdirectory(drivers)
# add_subdirectory(generated)

set(EXECUTABLE ${PROJECT_NAME}.out)

add_executable(${EXECUTABLE} )

target_sources(${EXECUTABLE} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/system_stm32f4xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/startup_stm32f411xe.s
)

target_include_directories(${EXECUTABLE} PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Inc
)

target_compile_definitions(${EXECUTABLE} PRIVATE
    -DUSE_HAL_DRIVER
    -DSTM32F411xE
    -D${BOARD}
)

target_link_libraries(${EXECUTABLE} PRIVATE f4_drivers led)

target_compile_options(${EXECUTABLE} PRIVATE
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard

    -fdata-sections
    -ffunction-sections

    -Wall

    $<$<CONFIG:Debug>:-Og>
    -gdwarf-2
    -fno-exceptions
)

target_link_options(${EXECUTABLE} PRIVATE
    -T${CMAKE_SOURCE_DIR}/generated/STM32F411VETx_FLASH.ld
    -mcpu=cortex-m4
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard

    -specs=nano.specs

    -lc
    -lm
    -lnosys

    -Wl,-Map=${CMAKE_CURRENT_SOURCE_DIR}/build/${PROJECT_NAME}.map,--cref
    -Wl,--gc-sections
    -Wl,--print-memory-usage
)


# Print executable size
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-size ${EXECUTABLE})

# Create hex file
add_custom_command(TARGET ${EXECUTABLE}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${EXECUTABLE} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${EXECUTABLE} ${PROJECT_NAME}.bin)