# Guitar Signal Processor (GSP)

An attempt to create guitar multi-effect using STM32F411 discovery board.

# Getting started

## Windows
### Prepare WSL for ARM compilation
1. Open PowerShell as admin and open WSL. If it doesn't work out of box google "WSL for windows"
```
wsl
```
2. Install required packages
```
sudo apt update
sudo apt upgrade
sudo apt install make build-essential cmake git gcc-arm-none-eabi gcc-arm-none-eabi-source
```
3. Close shell

### Build
1. Generate project files using CubeMX or CubeIDE
2. Open terminal in project's root and go to WSL:
```
wsl
make                # compile
make flashTarget    # flash board
```
