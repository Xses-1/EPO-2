//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#ifndef EPO2_STATES_H
#define EPO2_STATES_H

#include "arguments.h"
#include "direction.h"

/**
 * These are all possible states that the controller can be in.
 */
enum RobotState
{
	AT_S          = 1,
	START_FROM_S  = 2,
	FROM_S        = 3,
	STOP_FROM_S   = 4,
	START_ROT_S   = 101,
	DELAY_ROT_S   = 102,
	ROT_S         = 103,
	STOP_ROT_S    = 104,
	AT_I          = 201,
	START_FROM_I  = 202,
	FROM_I        = 203,
	START_ROT_L_I = 301,
	START_ROT_L_R = 302,
	DELAY_ROT_I   = 303,
	ROT_I         = 304,
	STOP_ROT_I    = 305,
	ENC_M         = 401,
	START_ROT_M   = 402,
	DELAY_ROT_M   = 403,
	STOP_ROT_M    = 404,
	START_FROM_M  = 405,
	DELAY_FROM_M  = 406,
	FROM_M        = 407,
	STOP_FROM_M   = 408,
	ROT_M         = 409,
	DELAY_TO_I    = 501,
	TO_I          = 502,
	STOP_TO_I     = 503,
	STOP_TO_S     = 504,
	FINISHED      = 1001
};

typedef enum RobotState RobotState;

/**
 * All possible states that the controller can be in are divided into the
 * following sections.
 */
enum GlobalState
{
	STATION          = 0,
	ROT_STATION      = 1,
	INTERSECTION     = 2,
	ROT_INTERSECTION = 3,
	MIDPOINT         = 4,
	MINE             = 5,
	OTHER            = 10
};

typedef enum GlobalState GlobalState;

/**
 * Returns the category of the given robot state.
 */
GlobalState globalState(RobotState robotState);

struct TargetStations
{
	int *targets;
	int targetAmount;
	int currentTarget; // should be the index of `targets`
	int start;
};

typedef struct TargetStations TargetStations;

void getTargets(PROGRAM_ARGS *args, TargetStations *targets);

struct StateData
{
	int row;
	int col;
	Direction direction;
};

typedef struct StateData StateData;

#endif//EPO2_STATES_H
