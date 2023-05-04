//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#include <stdio.h>

#include "../Control/Algorithm/queue.h"

void appendData(Queue *queue)
{
	appendToQueue(queue, 1, 2, 3);
	appendToQueue(queue, 4, 5, 6);
}

void takeData(Queue *queue)
{
	int row, col, dist;
	takeFromQueue(queue, &row, &col, &dist);
	printf(" > %d %d %d\n", row, col, dist);
	takeFromQueue(queue, &row, &col, NULL);
	printf(" > %d %d %d\n", row, col, dist);
}

int main()
{
	Queue *queue = createQueue();
	printQueue(queue);
	appendData(queue);
	printQueue(queue);
	takeData(queue);
	printQueue(queue);
	return 0;
}
