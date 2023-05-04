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

struct QueueNode
{
	int col;
	int row;
	int dist;
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
void appendToQueue(Queue *queue, int row, int col, int dist);

/**
 * Removes the first node from the queue. Its data is written to the addresses
 * given to the function.
 *
 * If there is no data to take from the queue, nothing will be written to the
 * given addresses. For any of the addresses, nothing will be written if NULL
 * is given as its value.
 */
void takeFromQueue(Queue *queue, int *row, int *column, int *distance);

/**
 * Prints the length of the queue and the values of each queue element. This
 * function exists for debugging purposes.
 */
void printQueue(const Queue *queue);

#endif//EPO2_QUEUE_H
