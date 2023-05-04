//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdio.h>
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

void appendToQueue(Queue *queue, int row, int col, int dist)
{
	QueueNode *newNode = (QueueNode *) malloc(sizeof(QueueNode));
	newNode->next = NULL;
	newNode->row = row;
	newNode->col = col;
	newNode->dist = dist;
	size_t length = getQueueLength(queue);
	if (length == 0)
	{
		queue->first = newNode;
		queue->last = newNode;
	} else
	{
		queue->last->next = newNode;
		queue->last = newNode;
	}
}

/**
 * Writes VALUE to ADDRESS if and only if ADDRESS does not equal NULL.
 */
void writeValue(int *address, int value)
{
	if (address != NULL)
	{
		*address = value;
	}
}

void takeFromQueue(Queue *queue, int *row, int *column, int *distance)
{
	if (!getQueueLength(queue))
	{
		return;
	}
	QueueNode *first = queue->first;
	queue->first = queue->first->next;
	writeValue(row, first->row);
	writeValue(column, first->col);
	writeValue(distance, first->dist);
	free(first);
}

void printQueue(const Queue *queue)
{
	size_t queueLength = getQueueLength(queue);
	printf("queue length: %zu\n", queueLength);
	if (queueLength)
	{
		printf("index\trow\tcolumn\tdistance\n");
	}
	QueueNode *cursor = queue->first;
	size_t index = 0;
	while (cursor != NULL)
	{
		printf("%zu\t%d\t%d\t%d\n", index, cursor->row,
		       cursor->col, cursor->dist);
		index += 1;
		cursor = cursor->next;
	}
}
