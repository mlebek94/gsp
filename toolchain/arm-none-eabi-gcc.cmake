set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

if(MINGW OR CYGWIN OR WIN32)
    set(UTIL_SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(UTIL_SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX arm-none-eabi-)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -Wall -Wpedantic -Os -fdata-sections -ffunction-sections -Wl,--gc-sections -specs=nano.specs")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} -fno-exceptions -fno-rtti -fno-threadsafe-statics")
add_link_options(-lc -lm -lnosys -Wl,--gc-sections -Wl,--print-memory-usage )

set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_SIZE_UTIL ${TOOLCHAIN_PREFIX}size)

set(CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX ".elf")

function(print_size target_ )
    add_custom_command(TARGET ${target_}
        POST_BUILD
        COMMAND arm-none-eabi-size ${target_}${CMAKE_EXECUTABLE_SUFFIX_CXX}
    )
endfunction()

function(create_hex target_ )
    add_custom_command(TARGET ${target_}
        POST_BUILD
        COMMAND arm-none-eabi-objcopy -O ihex ${target_}${CMAKE_EXECUTABLE_SUFFIX_CXX} ${target_}.hex
        COMMAND arm-none-eabi-objcopy -O binary ${target_}${CMAKE_EXECUTABLE_SUFFIX_CXX} ${target_}.bin
    )
endfunction()

function(build_elf target_ sources_ includes_ libraries_ flags_)
    add_executable(${target_})

    target_sources(${target_} PRIVATE ${sources_})
    target_include_directories(${target_} PUBLIC ${includes_})
    target_link_libraries(${target_} PRIVATE ${libraries_})
    target_link_options(${target_} PRIVATE ${flags_})

    print_size(${target_})
    create_hex(${target_})
endfunction()
