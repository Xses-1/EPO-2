//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdio.h>

#include "board.h"
#include "defaults.h"

int calculatePath(int **board,
		  int startRow,
		  int startCol,
		  int destRow,
		  int destCol)
{
	return -1;
}

void printPadded(int value)
{
	char s[6];
	sprintf(s, "%d", value);
	printf("%5s", s);
}

void printHeader()
{
	printf(" row / col");
	for (int i = 1; i < N_COLS + 1; ++i)
	{
		printPadded(i - 1);
	}
	printf("\n");
	for (int i = 0; i < 79; ++i)
	{
		printf("-");
	}
}

void printBoard(const int **board)
{
	printHeader();
	for (int i = 0; i < N_ROWS; ++i)
	{
		printPadded(i);
		printf("  |  ");
		for (int j = 0; j < N_COLS; ++j)
		{
			printPadded(board[i][j]);
		}
		printf("\n");
	}
}
