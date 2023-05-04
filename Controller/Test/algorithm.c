//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#include <stdio.h>

#include "../Control/Algorithm/board.h"
#include "../Control/Algorithm/defaults.h"

#define START_STATION 1
#define DESTINATION 12

int **getBoard()
{
	int **board = getDefaultBoard();
	printBoard(board);
	return board;
}

void getLocations(int *startRow, int *startCol, int *destRow, int*destCol)
{
	getStationLocation(START_STATION, startRow, startCol);
	getStationLocation(DESTINATION, destRow, destCol);
}

int main()
{
	int **board = getBoard();
	int startRow, startCol, destRow, destCol;
	getLocations(&startRow, &startCol, &destRow, &destCol);
	int dist = calculatePath(board, startRow, startCol, destRow, destCol);
	printBoard(board);
	printf("\ndistance: %d\n", dist);
	return 0;
}
