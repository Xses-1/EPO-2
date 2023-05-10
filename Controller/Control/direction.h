//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#ifndef EPO2_DIRECTION_H
#define EPO2_DIRECTION_H

enum Direction
{
	NORTH = 2,
	EAST = 3,
	SOUTH = 4,
	WEST = 5
};

typedef enum Direction Direction;

/**
 * Returns the string representing the given direction.
 */
char *directionString(Direction direction);

/**
 * Returns the direction to the left of the given direction.
 */
Direction leftDirection(Direction direction);

/**
 * Returns the direction to the left of the given direction.
 */
Direction rightDirection(Direction direction);

/**
 * Returns the direction opposite of the given direction.
 */
Direction oppDirection(Direction direction);

#endif//EPO2_DIRECTION_H
