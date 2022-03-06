#pragma once

#include "gpio.h"

struct led_config_t {
    GPIO_TypeDef* port;
    uint16_t pin;
    bool default_state{false};
};

class Led {
public:
    Led(const led_config_t& cfg) : config{cfg} {
        config.default_state ? on() : off();
    }

    void on() {
        HAL_GPIO_WritePin(config.port, config.pin, GPIO_PIN_SET);
    }

    void off() {
        HAL_GPIO_WritePin(config.port, config.pin, GPIO_PIN_RESET);
    }

    void toggle() {
        HAL_GPIO_TogglePin(config.port, config.pin);
    }
    bool is_on() const {
        return HAL_GPIO_ReadPin(config.port, config.pin) == GPIO_PIN_SET;
    }
private:
    const led_config_t& config;
};
