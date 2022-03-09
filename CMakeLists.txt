cmake_minimum_required(VERSION 3.10)

project(guitar-signal-processor VERSION 0.0.1 LANGUAGES CXX C ASM)

include(${CMAKE_CURRENT_SOURCE_DIR}/toolchain/arm-none-eabi-gcc.cmake)

add_subdirectory(vendor)
add_subdirectory(lib)
add_subdirectory(app)

add_executable(${PROJECT_NAME})

target_sources(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/stm32f4xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Src/system_stm32f4xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/startup_stm32f411xe.s
)

target_include_directories(${PROJECT_NAME} PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}/generated/Core/Inc
)

target_link_libraries(${PROJECT_NAME} PRIVATE f4_drivers led)

target_link_options(${PROJECT_NAME} PRIVATE
    -T${CMAKE_SOURCE_DIR}/generated/STM32F411VETx_FLASH.ld
    -Wl,-Map=${CMAKE_CURRENT_SOURCE_DIR}/build/${PROJECT_NAME}.map,--cref
)

# Print PROJECT_NAME size
add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND arm-none-eabi-size ${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX_CXX})

# Create hex file
add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX_CXX} ${PROJECT_NAME}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${PROJECT_NAME}${CMAKE_EXECUTABLE_SUFFIX_CXX} ${PROJECT_NAME}.bin)
