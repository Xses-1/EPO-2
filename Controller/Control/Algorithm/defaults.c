//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdlib.h>
#include <stdio.h>

#include "defaults.h"

const int DEFAULT_BOARD[N_ROWS][N_COLS] = {
	{-1, -1, -1, -1,  0, -1,  0, -1,  0, -1, -1, -1, -1},
	{-1, -1, -1, -1,  0, -1,  0, -1,  0, -1, -1, -1, -1},
	{-1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1},
	{-1, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1},
	{ 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
	{-1, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1},
	{ 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
	{-1, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1},
	{ 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0},
	{-1, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1},
	{-1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1},
	{-1, -1, -1, -1,  0, -1,  0, -1,  0, -1, -1, -1, -1},
	{-1, -1, -1, -1,  0, -1,  0, -1,  0, -1, -1, -1, -1}
};

const int STATION_ROWS[] =
	{12, 12, 12, 8, 6, 4, 0, 0, 0, 4, 6, 8};
const int STATION_COLS[] =
	{4, 6, 8, 12, 12, 12, 8, 6, 4, 0, 0, 0};

int **getDefaultBoard()
{
	int **board = (int **) malloc(sizeof(int *) * N_ROWS);
	for (int i = 0; i < N_ROWS; ++i)
	{
		board[i] = (int *) malloc(sizeof(int) * N_COLS);
		for (int j = 0; j < N_COLS; ++j)
		{
			board[i][j] = DEFAULT_BOARD[i][j];
		}
	}
	return board;
}

void getStationLocation(int station, int *row, int *col)
{
	if (station < 1 || station > 12)
	{
		printf("illicit station identifier: %d\n", station);
		return;
	}
	station -= 1;
	*row = STATION_ROWS[station];
	*col = STATION_COLS[station];
}
