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
void initControl(PROGRAM_ARGS *args);

/**
 * Returns the next assignment for the robot.
 */
uint8_t getAssignment();

/**
 * Handles the given information as information retrieved from the robot.
 */
void handleData(uint8_t data);

#endif//EPO2_CONTROL_H
