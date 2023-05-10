//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#include "direction.h"

char *directionString(Direction direction)
{
	switch (direction)
	{
	case NORTH:
		return "NORTH";
	case EAST:
		return "EAST";
	case SOUTH:
		return "SOUTH";
	default:
		return "WEST";
	}
}

Direction leftDirection(Direction direction)
{
	switch (direction)
	{
	case NORTH:
		return WEST;
	case EAST:
		return NORTH;
	case SOUTH:
		return EAST;
	case WEST:
		return SOUTH;
	}
}

Direction rightDirection(Direction direction)
{
	for (int i = 0; i < 3; ++i)
	{
		direction = leftDirection(direction);
	}
	return direction;
}

Direction oppDirection(Direction direction)
{
	for (int i = 0; i < 2; ++i)
	{
		direction = leftDirection(direction);
	}
	return direction;
}
