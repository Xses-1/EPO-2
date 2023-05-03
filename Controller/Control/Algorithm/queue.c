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

void appendToQueue(Queue *queue, NodeData *data)
{
	QueueNode *newNode = (QueueNode *) malloc(sizeof(QueueNode));
	newNode->next = NULL;
	newNode->data = data;
	queue->last->next = newNode;
	queue->last = newNode;
}

NodeData *takeFromQueue(Queue *queue)
{
	if (!getQueueLength(queue))
	{
		return NULL;
	}
	QueueNode *first = queue->first;
	queue->first = queue->first->next;
	NodeData *data = first->data;
	free(first);
	return data;
}
