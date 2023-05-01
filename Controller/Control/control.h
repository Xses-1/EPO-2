//
// Created by Thijs J.A. van Esch on 1-5-2023.
//

#ifndef EPO2_CONTROL_H
#define EPO2_CONTROL_H

#include <stddef.h>
#include <stdint.h>

/**
 * Parameters:
 * 	start		the station at which the robot starts
 * 	stations	the stations that the robot has to reach
 * 	n		the amount of elements in the `stations` array
 */
struct PROGRAM_ARGS
{
	uint8_t start;
	uint8_t *stations;
	size_t n;
};

typedef struct PROGRAM_ARGS PROGRAM_ARGS;

/**
 * Parses the given command line arguments.
 *
 * If a nonzero value is returned by this function, it means invalid arguments
 * are given and the program needs to exit after prompting the user to input
 * valid data.
 */
int parseArguments(int argc, const char *argv[], PROGRAM_ARGS *args);

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
