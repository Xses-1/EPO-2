//
// Created by Thijs J.A. van Esch on 30-4-23.
//

#ifndef EPO2_SERIAL_H
#define EPO2_SERIAL_H

#include <stddef.h>
#include <stdint.h>

/**
 * Initializes the serial interface for serial communication with the robot.
 */
int initSio();

/**
 * Reads BYTES bytes from the serial interface.
 */
int readData(uint8_t *data, size_t bytes);

/**
 * Writes BYTES bytes of the given data to the serial interface.
 */
int writeData(const uint8_t *data, size_t bytes);

/**
 * Reads a single byte from the serial interface.
 *
 * Calling this function should be equivalent to `readData(byte, 1)`.
 */
int readByte(uint8_t *byte);

/**
 * Writes a single byte over the serial interface.
 *
 * Calling this function should be equivalent to `writeData(byte, 1)`.
 */
int writeByte(const uint8_t *byte);

/**
 * Properly closes the connection to the robot.
 */
int closeSio();

#endif //EPO2_SERIAL_H
