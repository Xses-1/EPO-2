//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#define TEST_OP 1

#include <stdio.h>

#include "../Control/Algorithm/queue.h"
#include "../Control/communication.h"

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

void testOpQueue()
{
	showOpQueue();
	queueOp(ROBOT_FORWARD);
	showOpQueue();
	queueOp(ROBOT_RIGHT);
	queueOp(ROBOT_LEFT);
	showOpQueue();
	RobotOp next;
	next = nextOp();
	//  printf("%s\n", opName(next));
	next = nextOp();
	showOpQueue();
	// printf("%s\n", opName(next));
	next = nextOp();
	//  printf("%s\n", opName(next));
	showOpQueue();
}

int main()
{
#if !TEST_OP
	Queue *queue = createQueue();
	printQueue(queue);
	appendData(queue);
	printQueue(queue);
	takeData(queue);
	printQueue(queue);
#else
	testOpQueue();
#endif
	return 0;
}
