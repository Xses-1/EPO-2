//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdio.h>

#include "board.h"
#include "defaults.h"

int calculatePath(Board *board, Location start, Location end)
{
	return -1;
}

void printPadded(int value)
{
	char s[6];
	sprintf(s, "%d", value);
	printf("%5s", s);
}

void printBoard(const Board *board)
{
	for (int i = 0; i < N_COLS + 1; ++i)
	{
		if (i >= 1)
		{
			printPadded(i - 1);
		} else
		{
			printf(" row / col");
		}
	}
	printf("\n");
	for (int i = 0; i < 79; ++i)
	{
		printf("-");
	}
	printf("\n");
	for (int i = 0; i < N_ROWS; ++i)
	{
		printPadded(i);
		printf("  |  ");
		for (int j = 0; j < N_COLS; ++j)
		{
			printPadded((*board)[i][j]);
		}
		printf("\n");
	}
}
