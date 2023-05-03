//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_BOARD_H
#define EPO2_BOARD_H

#include "types.h"

/**
 * Calculates the shorts path between START and END. This path is written to
 * the board.
 *
 * The function return the distance between start and end, or -1 if the
 * destination can not be reached from the given starting point.
 */
int calculatePath(Board *board, Location start, Location end);

/**
 * Prints the given board to the console.
 */
void printBoard(const Board *board);

#endif//EPO2_BOARD_H
