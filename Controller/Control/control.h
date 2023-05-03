//
// Created by Thijs J.A. van Esch on 1-5-2023.
//

#ifndef EPO2_CONTROL_H
#define EPO2_CONTROL_H

#include <stdint.h>

#include "arguments.h"

/**
 * Initializes the control unit.
 */
int initControl(PROGRAM_ARGS *args);

/**
 * Writes the next robot assignment to the given address.
 */
int getAssignment(uint8_t *assignment);

/**
 * Should parse the given information, which is assumed to have been retrieved
 * from the robot.
 */
int handleData(uint8_t *data);

#endif//EPO2_CONTROL_H
