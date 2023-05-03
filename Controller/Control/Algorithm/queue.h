//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_QUEUE_H
#define EPO2_QUEUE_H

#include <stddef.h>
#include <stdint.h>

#include "types.h"

struct QueueNode;

typedef struct QueueNode QueueNode;

struct NodeData
{
	Location location;
	int cellValue;
};

typedef struct NodeData NodeData;

struct QueueNode
{
	NodeData *data;
	QueueNode *next;
};

struct Queue
{
	QueueNode *first;
	QueueNode *last;
};

typedef struct Queue Queue;

/**
 * Creates an empty queue and returns its address.
 */
Queue *createQueue();

/**
 * Returns the length of the given queue.
 */
size_t getQueueLength(const Queue *queue);

/**
 * Appends the given data to the given queue.
 */
void appendToQueue(Queue *queue, NodeData *data);

/**
 * Removes the first node from the queue. Its data is returned.
 *
 * If there is no data to take from the queue, NULL will be returned.
 */
NodeData *takeFromQueue(Queue *queue);

#endif//EPO2_QUEUE_H
