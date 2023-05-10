//
// Created by Thijs J.A. van Esch on 1-5-2023.
//

#define DELAY_CYCLES 10

#include <stdio.h>

#include "control.h"

#include "communication.h"
#include "states.h"
#include "stations.h"

#include "Algorithm/board.h"
#include "Algorithm/defaults.h"

RobotState state = AT_S;
StateData stateData;
TargetStations targets;

RobotStatus incomingData;

int **board;

void initControl(PROGRAM_ARGS *args)
{
	getTargets(args, &targets);
	int row, col;
	getStationLocation(targets.start, &row, &col);
	stateData.row = row;
	stateData.col = col;
	stateData.direction = stationDirection(targets.start);
	board = getDefaultBoard();
	int target = targets.targets[targets.currentTarget];
	int destRow, destCol;
	getStationLocation(target, &destRow, &destCol);
	calculatePath(board, row, col, destRow, destCol);
	printBoard(board);
}

/**
 * Writes the next board location to the given addresses.
 */
void getNextLocation(int *row, int *col)
{
	int best = -1;
	int bestValue = -100;
	for (int i = 0; i < 4; ++i)
	{
		int nextRow, nextCol;
		getPossibleDirection(i, stateData.row, stateData.col,
				     &nextRow, &nextCol);
		if (!isValidLocation(nextRow, nextCol))
		{
			continue;
		}
		int cellValue = board[nextRow][nextCol];
		if (best == -1 || cellValue < bestValue)
		{
			best = i;
			bestValue = cellValue;
		}
	}
	getPossibleDirection(best, stateData.row, stateData.col, row, col);
}

/**
 * Returns the direction the robot should face next.
 *
 * This function assumes the robot is idle at an intersection.
 */
Direction nextDirection()
{
	int nextRow, nextCol;
	getNextLocation(&nextRow, &nextCol);
	if (nextRow < stateData.row)
	{
		return SOUTH;
	} else if (nextRow > stateData.row)
	{
		return NORTH;
	} else if (nextCol < stateData.col)
	{
		return WEST;
	} else
	{
		return EAST;
	}
}

/**
 * Returns a boolean indicating whether the robot is currently facing the right
 * direction.
 */
bool facingCorrectDirection(bool atStation)
{
	if (atStation)
	{
		int station = targets.targets[targets.currentTarget - 1];
		return stateData.direction == stationDirection(station);
	} else
	{
		return nextDirection() == stateData.direction;
	}
}

/**
 * Returns a boolean indicating whether the current station is the final
 * station.
 */
bool isFinalStation()
{
	return targets.currentTarget - 1 == targets.targetAmount;
}

/**
 * Calculates the next location the robot will be in when moving forward one
 * cell, in the direction it is currently facing, and writes the obtained
 * values as the new location of the robot.
 */
void incrementLocation()
{
	if (stateData.direction == NORTH)
	{
		stateData.row -= 1;
	} else if (stateData.direction == EAST)
	{
		stateData.col += 1;
	} else if (stateData.direction == SOUTH)
	{
		stateData.row += 1;
	} else
	{
		stateData.col -= 1;
	}
}

/**
 * Returns a true value if all three line sensors detect a line.
 */
bool blockDetected()
{
	return    incomingData.leftLine
	       && incomingData.middleLine
	       && incomingData.rightLine;
}

/**
 * Returns a true value if a line is detected.
 */
bool lineDetected()
{
	return     !incomingData.leftLine
		&&  incomingData.middleLine
		&& !incomingData.rightLine;
}

/**
 * Returns a true value if the robot is moving toward a station.
 */
bool movingToStation()
{
	return (stateData.row == 1 || stateData.row == 11)
		&& (stateData.col == 1 || stateData.col == 11);
}

/**
 * This function should be called if the robot has detected a mine.
 */
void encounteredMine()
{
	board[stateData.row][stateData.col] = -2;
}

uint8_t getAssignment()
{
	static int delayCounter = 0;
	switch (state)
	{
	case AT_S:
		if (isFinalStation())
		{
			state = FINISHED;
		} else if (facingCorrectDirection(true))
		{
			state = START_ROT_S;
		} else
		{
			state = START_FROM_S;
		}
		return ROBOT_NOOP;
	case START_FROM_S:
		incrementLocation();
		state = FROM_S;
		return ROBOT_FORWARD;
	case FROM_S:
		if (blockDetected())
		{
			state = STOP_FROM_S;
		}
		return ROBOT_NOOP;
	case STOP_FROM_S:
		state = AT_I;
		incrementLocation();
		return ROBOT_STOP;
	case START_ROT_S:
		state = DELAY_ROT_S;
		return ROBOT_LEFT;
	case DELAY_ROT_S:
		delayCounter += 1;
		if (delayCounter >= DELAY_CYCLES)
		{
			delayCounter = 0;
			state = ROT_S;
		}
		return ROBOT_NOOP;
	case ROT_S:
		if (lineDetected())
		{
			state = STOP_ROT_S;
		} else if (blockDetected() && movingToStation())
		{
			state = STOP_TO_S;
		} else if (blockDetected())
		{
			state = DELAY_TO_I;
		}
		return ROBOT_NOOP;
	case STOP_ROT_S:
		stateData.direction = oppDirection(stateData.direction);
		state = AT_S;
		return ROBOT_STOP;
	case AT_I:
		if (facingCorrectDirection(false))
		{
			state = START_FROM_I;
		} else if (nextDirection()
			   == leftDirection(stateData.direction))
		{
			state = START_ROT_L_I;
		} else
		{
			state = START_ROT_L_R;
		}
		return ROBOT_NOOP;
	case START_FROM_I:
		incrementLocation();
		state = FROM_I;
		return ROBOT_FORWARD;
	case FROM_I:
		if (incomingData.mineDetected)
		{
			state = ENC_M;
		} else if (blockDetected())
		return ROBOT_NOOP;
	case START_ROT_L_I:
		stateData.direction = leftDirection(stateData.direction);
		state = DELAY_ROT_I;
		return ROBOT_LEFT;
	case START_ROT_L_R:
		stateData.direction = rightDirection(stateData.direction);
		state = DELAY_ROT_I;
		return ROBOT_RIGHT;
	case DELAY_ROT_I:
		delayCounter += 1;
		if (delayCounter >= DELAY_CYCLES)
		{
			delayCounter = 0;
			state = ROT_I;
		}
		return ROBOT_NOOP;
	case ROT_I:
		if (lineDetected())
		{
			state = STOP_ROT_I;
		}
		return ROBOT_NOOP;
	case STOP_ROT_I:
		state = AT_I;
		return ROBOT_STOP;
	case ENC_M:
		encounteredMine();
		state = START_ROT_M;
		return ROBOT_STOP;
	case START_ROT_M:
		state = DELAY_ROT_M;
		return ROBOT_LEFT;
	case DELAY_ROT_M:
		delayCounter += 1;
		if (delayCounter >= DELAY_CYCLES)
		{
			delayCounter = 0;
			state = ROT_I;
		}
		return ROBOT_NOOP;
	case ROT_M:
		if (lineDetected())
		{
			state = STOP_ROT_M;
		}
		return ROBOT_NOOP;
	case STOP_ROT_M:
		state = START_FROM_M;
		stateData.direction = oppDirection(stateData.direction);
		return ROBOT_STOP;
	case START_FROM_M:
		state = DELAY_FROM_M;
		return ROBOT_FORWARD;
	case DELAY_FROM_M:
		delayCounter += 1;
		if (delayCounter >= DELAY_CYCLES)
		{
			delayCounter = 0;
			state = FROM_M;
		}
		return ROBOT_NOOP;
	case FROM_M:
		if (blockDetected())
		{
			state = STOP_FROM_M;
		}
		return ROBOT_NOOP;
	case STOP_FROM_M:
		state = AT_I;
		incrementLocation();
		return ROBOT_STOP;
	case DELAY_TO_I:
		delayCounter += 1;
		if (delayCounter >= DELAY_CYCLES)
		{
			delayCounter = 0;
			state = TO_I;
		}
		return ROBOT_NOOP;
	case TO_I:
		if (blockDetected())
		{
			state = STOP_TO_I;
		}
		return ROBOT_NOOP;
	case STOP_TO_I:
		incrementLocation();
		return ROBOT_STOP;
	case STOP_TO_S:
		targets.currentTarget += 1;
		state = AT_S;
		return ROBOT_STOP;
	case FINISHED:
		printf("FINISHED\n");
		return ROBOT_NOOP;
	}
}

void handleData(uint8_t data)
{
	parseIncomingData(data, &incomingData);
}