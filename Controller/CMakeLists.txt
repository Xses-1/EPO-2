cmake_minimum_required(VERSION 3.25)
project(EPO2 C)

set(CMAKE_C_STANDARD 11)

# Main application
add_executable(EPO2 main.c Serial/platform.h Serial/params.h Serial/serial.h Serial/serial.c)

# Tests:
add_executable(SerialTest Test/serial.c Serial/platform.h Serial/params.h Serial/serial.h Serial/serial.c)
add_executable(SerialMonitor Test/monitor.c Serial/platform.h Serial/params.h Serial/serial.h Serial/serial.c)