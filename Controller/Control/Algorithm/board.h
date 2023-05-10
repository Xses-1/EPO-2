//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_BOARD_H
#define EPO2_BOARD_H

/**
 * Is able to write four different positions to NEWCOL/NEWROW. The value of
 * INDEX must be in the range [0, 4).
 *
 * Note that this function may write illicit locations to the given addresses.
 */
void getPossibleDirection(int index,
			  int currentRow,
			  int currentCol,
			  int *newRow,
			  int *newCol);

/**
 * Returns a boolean indicating whether the given location is valid.
 */
bool isValidLocation(int row, int col);

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
