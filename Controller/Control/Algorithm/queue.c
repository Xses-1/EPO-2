//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdlib.h>
#include <stdint.h>

#include "queue.h"

Queue *createQueue()
{
	Queue *queue = (Queue *) malloc(sizeof(Queue));
	queue->first = NULL;
	queue->last = NULL;
	return queue;
}

size_t getQueueLength(const Queue *queue)
{
	QueueNode *cursor = queue->first;
	size_t queueLength = 0;
	while (cursor != NULL)
	{
		queueLength += 1;
		cursor = cursor->next;
	}
	return queueLength;
}

void appendToQueue(Queue *queue, int value)
{
	QueueNode *newNode = (QueueNode *) malloc(sizeof(QueueNode));
	newNode->next = NULL;
	newNode->value = value;
	queue->last->next = newNode;
	queue->last = newNode;
}

int takeFromQueue(Queue *queue)
{
	if (!getQueueLength(queue))
	{
		return INT32_MIN;
	}
	QueueNode *first = queue->first;
	queue->first = queue->first->next;
	int value = first->value;
	free(first);
	return value;
}
