//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_DEFAULTS_H
#define EPO2_DEFAULTS_H

#define N_ROWS 13
#define N_COLS 13

#include "types.h"

/**
 * Returns a newly created board with all default values.
 */
Board *getDefaultBoard();

/**
 * Returns the location for the given station. This location is determined
 * from the given station identifier, which must be in the range [1, 12].
 * If a value is given that is not in this range, an error will be printed
 * to the console.
 */
Location getStationLocation(int station);

#endif//EPO2_DEFAULTS_H
