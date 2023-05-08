//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#include <stdio.h>
#include <stdlib.h>

#include "communication.h"

RobotStatus parseRobotStatus(uint8_t incoming)
{
	RobotStatus robotStatus;
	robotStatus.isMakingUTurn = incoming & (1 << 7) ? 1 : 0;
	robotStatus.isTurning = incoming & (1 << 6) ? 1 : 0;
	robotStatus.isDriving = incoming & (1 << 5) ? 1 : 0;
	robotStatus.leftLine = incoming & (1 << 4) ? 0 : 1;
	robotStatus.middleLine = incoming & (1 << 3) ? 0 : 1;
	robotStatus.rightLine = incoming & (1 << 2) ? 0 : 1;
	robotStatus.mineDetected = incoming & (1 << 1) ? 1 : 0;
	robotStatus.readBit = incoming & 1 ? 1 : 0;
	return robotStatus;
}

bool parseIncomingData(uint8_t incoming, RobotStatus *robotStatus)
{
	RobotStatus parsed = parseRobotStatus(incoming);
	if (parsed.readBit)
	{
		*robotStatus = parsed;
		return false;
	}
	return true;
}

char *opName(RobotOp op)
{
	switch (op)
	{

		case ROBOT_NOOP:
			return "ROBOT_NOOP // 000";
		case ROBOT_LEFT:
			return "ROBOT_LEFT // 001";
		case ROBOT_RIGHT:
			return "ROBOT_RIGHT // 010";
		case ROBOT_FORWARD:
			return "ROBOT_FORWARD // 011";
		case ROBOT_STOP:
			return "ROBOT_STOP // 100";
	}
}

struct OpNode;

typedef struct OpNode OpNode;

struct OpNode
{
	RobotOp op;
	OpNode *next;
};

struct OpQueue
{
	OpNode *first;
	OpNode *last;
};

typedef struct OpQueue OpQueue;

//
// All operations will be added to this queue.
//
OpQueue opQueue = {NULL, NULL};

/**
 * Returns the length of the operations queue.
 */
size_t opQueueLength()
{
	OpNode *cursor = opQueue.first;
	size_t length = 0;
	while (cursor != NULL)
	{
		length += 1;
		cursor = cursor->next;
	}
	return length;
}

/**
 * Returns a newly allocated `OpNode` with the given operation.
 */
OpNode *newNode(RobotOp op)
{
	OpNode *new = (OpNode *) malloc(sizeof(OpNode));
	new->next = NULL;
	new->op = op;
	return new;
}

void queueOp(RobotOp op)
{
	size_t queueLength = opQueueLength();
	OpNode *next = newNode(op);
	if (queueLength == 0)
	{
		opQueue.first = next;
		opQueue.last = next;
	} else
	{
		opQueue.last->next = next;
		opQueue.last = next;
	}
}

RobotOp nextOp()
{
	size_t queueLength = opQueueLength();
	if (queueLength == 0)
	{
		return ROBOT_NOOP;
	}
	OpNode *node = opQueue.first;
	RobotOp op = node->op;
	if (queueLength == 1)
	{
		opQueue.first = NULL;
		opQueue.last = NULL;
	} else
	{
		opQueue.first = node->next;
	}
	free(node);
	return op;
}

void showOpQueue()
{
	size_t queueLength = opQueueLength();
	if (queueLength == 0)
	{
		printf(" ###\tOpQueue\n\t<empty>\n");
		return;
	}
	printf(" ###\tOpQueue (%zu)\n", queueLength);
	size_t index = 0;
	OpNode *cursor = opQueue.first;
	while (cursor != NULL)
	{
		printf("\top %zu: %s\n", index, opName(cursor->op));
		cursor = cursor->next;
		index += 1;
	}
}
