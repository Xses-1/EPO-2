//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#include <stdlib.h>

#include "states.h"

GlobalState globalState(RobotState robotState)
{
	return robotState / 100;
}

void getTargets(PROGRAM_ARGS *args, TargetStations *targets)
{
	targets->start = args->start;
	targets->currentTarget = 1;
	targets->targets = (int *) malloc(sizeof(int) * (args->n + 1));
	*targets->targets = args->start;
	for (int i = 0; i < args->n; ++i)
	{
		*(targets->targets + i + 1) = *(args->stations + i);
	}
}
