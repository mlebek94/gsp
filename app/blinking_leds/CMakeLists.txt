set(NAME blinking_leds)
set(sources
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/i2s.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32f4xx_hal_msp.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32f4xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/system_stm32f4xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/startup_stm32f411xe.s
)
set(includes  ${CMAKE_CURRENT_SOURCE_DIR}/inc)
set(libraries f4_drivers led)
set(options -T${CMAKE_CURRENT_SOURCE_DIR}/STM32F411VETx_FLASH.ld -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/${NAME}.map,--cref)

build_elf(${NAME} "${sources}" "${includes}" "${libraries}" "${options}")
