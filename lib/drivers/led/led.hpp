#pragma once

#include "stm32f4xx_hal.h"

struct led_config_t {
    GPIO_TypeDef* port;
    uint16_t pin;
    bool default_state{false};
};

class Led {
public:
    Led(const led_config_t& cfg);

    void on();
    void off();
    void toggle();
    bool is_on() const;
private:
    const led_config_t& config;
};
