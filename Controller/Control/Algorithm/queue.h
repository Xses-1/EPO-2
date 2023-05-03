//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#ifndef EPO2_QUEUE_H
#define EPO2_QUEUE_H

#include <stddef.h>
#include <stdint.h>

struct QueueNode;

typedef struct QueueNode QueueNode;

struct QueueNode
{
	uint64_t value;
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
 * Appends the given integer to the given queue.
 */
void appendToQueue(Queue *queue, uint64_t value);

/**
 * Removes the first node from the queue. Its value is returned.
 *
 * If there is no value to take from the queue, INT32_MIN will be returned.
 */
uint64_t takeFromQueue(Queue *queue);

#endif//EPO2_QUEUE_H
