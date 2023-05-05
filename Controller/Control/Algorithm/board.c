//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdbool.h>
#include <stdio.h>

#include "board.h"
#include "defaults.h"
#include "queue.h"

const int POSSIBLE_ROW_DIFF[] = {-1, 0, 1, 0};
const int POSSIBLE_COL_DIFF[] = {0, 1, 0, -1};

/**
 * Is able to write four different positions to NEWCOL/NEWROW. The value of
 * INDEX must be in the range [0, 4).
 *
 * Note that this function may write illicit locations to the given addresses.
 */
void getPossibleDirection(int index,
			  int currentRow,
			  int currentCol,
			  int *newRow,
			  int *newCol)
{
	*newRow = currentRow + POSSIBLE_ROW_DIFF[index];
	*newCol = currentCol + POSSIBLE_COL_DIFF[index];
}

bool isValidLocation(int row, int col)
{
	bool isValidRow = row >= 0 && row < N_ROWS;
	bool isValidCol = col >= 0 && col < N_COLS;
	bool isValid = isValidRow && isValidCol;
#if PRINT_ALGORITHM_DEBUG
	printf("determined validity of %d/%d: %s\n", row, col,
	       isValid ? "valid" : "invalid");
	return isValid;
#endif
}

bool shouldMoveToLocation(int **board, int row, int col)
{
	if (!isValidLocation(row, col))
	{
		return false;
	}
	int cellValue = board[row][col];
	bool shouldMove = cellValue == 0;
#if PRINT_ALGORITHM_DEBUG
	printf("read value of %d/%d: %d\n", row, col, cellValue);
	printf("should move to %d/%d: %s\n", row, col,
	       shouldMove ? "true" : "false");
#endif
	return shouldMove;
}

void writeToBoard(int **board, int row, int col, int value)
{
#if PRINT_ALGORITHM_DEBUG
	printf("writing %d to %d/%d\n", value, row, col);
#endif
	board[row][col] = value;
}

int calculatePath(int **board,
		  int startRow,
		  int startCol,
		  int destRow,
		  int destCol)
{
	Queue *queue = createQueue();
	appendToQueue(queue, startRow, startCol, 1);
	writeToBoard(board, startRow, startCol, 1);
	int distance = -1;
	while (getQueueLength(queue))
	{
		int currentRow, currentCol, currentDist;
		takeFromQueue(queue, &currentRow, &currentCol, &currentDist);
#if PRINT_ALGORITHM_DEBUG
		printf("read from queue: %d / %d / %d\n", currentRow,
		       currentCol, currentDist);
#endif
		if (currentRow == destRow && currentCol == destCol
		    && distance == -1)
		{
			distance = currentDist;
		}
		for (int i = 0; i < 4; ++i)
		{
			int newRow, newCol;
			getPossibleDirection(i, currentRow, currentCol,
					     &newRow, &newCol);
			if (shouldMoveToLocation(board, newRow, newCol))
			{
				writeToBoard(board, newRow, newCol,
					     currentDist + 1);
				appendToQueue(queue, newRow, newCol,
					      currentDist + 1);
			}
		}
	}
	return distance;
}

void printPadded(int value, bool printZero)
{
	if (value == 0 && !printZero)
	{
		printf("   . ");
		return;
	} else if (value == -1 && !printZero)
	{
		printf("     ");
		return;
	}
	char s[6];
	sprintf(s, "%d", value);
	printf("%5s", s);
}

void printHeader()
{
	printf("\n row / col");
	for (int i = 1; i < N_COLS + 1; ++i)
	{
		printPadded(i - 1, true);
	}
	printf("\n");
	for (int i = 0; i < 79; ++i)
	{
		printf("-");
	}
	printf("\n");
}

void printBoard(int **board)
{
	printHeader();
	for (int i = 0; i < N_ROWS; ++i)
	{
		printPadded(i, true);
		printf("  |  ");
		for (int j = 0; j < N_COLS; ++j)
		{
			printPadded(board[i][j], false);
		}
		printf("\n");
	}
}
