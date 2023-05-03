//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "board.h"
#include "defaults.h"
#include "queue.h"

int **getEmptyMatrix()
{
	int **matrix = (int **) malloc(sizeof(int *) * N_ROWS);
	for (int row = 0; row < N_ROWS; ++row)
	{
		matrix[row] = (int *) malloc(sizeof(int) * N_COLS);
		for (int col = 0; col < N_COLS; ++col)
		{
			matrix[row][col] = 0;
		}
	}
	return matrix;
}

void freeMatrix(int **matrix)
{
	for (int row = 0; row < N_ROWS; ++row)
	{
		free(matrix + row);
	}
	free(matrix);
}

int locationsAreEqual(Location location1, Location location2)
{
	return location1.col == location2.col
	       && location1.row == location2.row;
}

int isValidLocation(Location location)
{
	return location.row > 0 && location.row < N_ROWS
	       && location.col > 0 && location.col < N_COLS;
}

Location getMovementPossibility(Location currentLocation, int movementIndex)
{
	switch (movementIndex)
	{
		case 0:
			currentLocation.row -= 1;
			break;
		case 1:
			currentLocation.col -= 1;
			break;
		case 2:
			currentLocation.col += 1;
			break;
		case 3:
			currentLocation.row += 1;
			break;
		default: // TODO: fix
			printf("illicit movementIndex\n");
	}
	return currentLocation;
}

int getBoardValue(const Board *board, Location location)
{
	return (*board)[location.row][location.col];
}

void setBoardValue(Board *board, Location location, int newValue)
{
	(*board)[location.row][location.col] = newValue;
}

int hasVisited(int **visitedLocations, Location location)
{
	return visitedLocations[location.row][location.col];
}

int calculatePath(Board *board, Location start, Location end)
{
	int **visited = getEmptyMatrix();
	visited[start.row][start.col] = 1;

	Queue *queue = createQueue();
	NodeData *element = (NodeData *) malloc(sizeof(NodeData));
	element->location = start;
	element->cellValue = 0;
	appendToQueue(queue, element);

	int distance = -1;

	while (getQueueLength(queue))
	{
		NodeData *cursor = takeFromQueue(queue);
		Location location = cursor->location;

		if (locationsAreEqual(location, end))
		{
			distance = cursor->cellValue;
			break;
		}

		for (int i = 0; i < 4; ++i)
		{
			Location newLocation;
			newLocation = getMovementPossibility(location, i);
			if (isValidLocation(newLocation)
			    && getBoardValue(board, newLocation) > 0
			    && !hasVisited(visited, newLocation))
			{
				visited[newLocation.row][newLocation.col] = 1;
				NodeData *adjacent =
					(NodeData *) malloc(sizeof(NodeData));
				adjacent->location = newLocation;
				adjacent->cellValue = distance + 1;
				setBoardValue(board, newLocation, distance + 1);
				appendToQueue(queue, adjacent);
			}
		}
	}

	return distance;
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
