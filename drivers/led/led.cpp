#include "led.hpp"

Led::Led(const led_config_t& cfg) : config{cfg} {
    config.default_state ? on() : off();
}

void Led::on() {
    HAL_GPIO_WritePin(config.port, config.pin, GPIO_PIN_SET);
}

void Led::off() {
    HAL_GPIO_WritePin(config.port, config.pin, GPIO_PIN_RESET);
}

void Led::toggle() {
    HAL_GPIO_TogglePin(config.port, config.pin);
}
bool Led::is_on() const {
    return HAL_GPIO_ReadPin(config.port, config.pin) == GPIO_PIN_SET;
}