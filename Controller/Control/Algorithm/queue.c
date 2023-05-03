//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdlib.h>

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

void appendToQueue(Queue *queue, Location *value)
{
	QueueNode *newNode = (QueueNode *) malloc(sizeof(QueueNode));
	newNode->next = NULL;
	newNode->location = value;
	queue->last->next = newNode;
	queue->last = newNode;
}

Location *takeFromQueue(Queue *queue)
{
	if (!getQueueLength(queue))
	{
		return NULL;
	}
	QueueNode *first = queue->first;
	queue->first = queue->first->next;
	Location *location = first->location;
	free(first);
	return location;
}
