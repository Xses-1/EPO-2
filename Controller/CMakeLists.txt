cmake_minimum_required(VERSION 3.25)
project(EPO2 C)

set(CMAKE_C_STANDARD 11)

add_executable(EPO2 main.c Serial/platform.h Serial/params.h Serial/serial.h Serial/serial.c)