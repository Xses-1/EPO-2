cmake_minimum_required(VERSION 3.25)
project(EPO2 C)

set(CMAKE_C_STANDARD 11)

set(    SOURCES
        Serial/platform.h
        Serial/params.h
        Serial/serial.h
        Serial/serial.c
        Control/control.h
        Control/control.c
        Control/operations.h
        Control/arguments.h
        Control/arguments.c
        Control/Algorithm/queue.c
        Control/Algorithm/queue.h
        Control/Algorithm/defaults.h
        Control/Algorithm/defaults.c
        Control/Algorithm/board.c
        Control/Algorithm/board.h
        Control/communication.c
        Control/communication.h)

### Main application
add_executable(EPO2 main.c ${SOURCES})

### Tests
add_executable(QueueTest        Test/queuetest.c    ${SOURCES})
add_executable(AlgorithmTest    Test/algorithm.c    ${SOURCES})
add_executable(SerialTest       Test/serial.c       ${SOURCES})
add_executable(SerialMonitor    Test/monitor.c      ${SOURCES})