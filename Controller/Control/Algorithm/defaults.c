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

Board getDefaultBoard()
{
	int **board = (int **) malloc(sizeof(int *) * N_ROWS);
	for (int i = 0; i < N_ROWS; ++i)
	{
		*(board + i) = (int *) malloc(sizeof(int) * N_COLS);
	}
	Board actualBoard = board;
	for (int i = 0; i < N_ROWS; ++i)
	{
		for (int j = 0; j < N_COLS; ++j)
		{
			actualBoard[i][j] = DEFAULT_BOARD[i][j];
		}
	}
	return actualBoard;
}

Location getStationLocation(int station)
{
	if (station < 1 || station > 12)
	{
		printf("illicit station identifier: %d\n", station);
	}
	int rows[12] = {12, 12, 12, 8, 6, 4, 0, 0, 0, 4, 6, 8};
	int cols[12] = {4, 6, 8, 12, 12, 12, 8, 6, 4, 0, 0, 0};
	Location stationLocation = {rows[station - 1], cols[station - 1]};
	return stationLocation;
}
