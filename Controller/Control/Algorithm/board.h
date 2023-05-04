//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_BOARD_H
#define EPO2_BOARD_H

/**
 * Calculates the shortest path between the start location and the destination.
 * This path is written to the board.
 *
 * The function returns the distance between start and end, or -1 if the
 * destination can not be reached from the given starting point.
 */
int calculatePath(int **board,
		  int startRow,
		  int startCol,
		  int destRow,
		  int destCol);

/**
 * Prints the given board to the console.
 */
void printBoard(int **board);

#endif//EPO2_BOARD_H
