//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_ARGUMENTS_H
#define EPO2_ARGUMENTS_H

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

#endif//EPO2_ARGUMENTS_H
