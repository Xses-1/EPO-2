//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#include <stdio.h>

#include "stations.h"

const int STATION_ROWS[] =
	{12, 12, 12, 8, 6, 4, 0, 0, 0, 4, 6, 8};
const int STATION_COLS[] =
	{4, 6, 8, 12, 12, 12, 8, 6, 4, 0, 0, 0};

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

