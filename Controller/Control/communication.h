//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#ifndef EPO2_COMMUNICATION_H
#define EPO2_COMMUNICATION_H

#include <stdbool.h>
#include <stdint.h>

struct RobotStatus
{
	bool leftLine;
	bool middleLine;
	bool rightLine;
	bool mineDetected;
	bool isDriving;
	bool isTurning;
	bool isMakingUTurn;
	bool readBit;
};

typedef struct RobotStatus RobotStatus;

/**
 * Parses the given data and writes the obtained values to the struct located
 * at the given address.
 *
 * The function assumes that it may write to this address.
 *
 * The function returns a true value if no data is available. If this is the
 * case, nothing will be written to the given address.
 */
bool parseIncomingData(uint8_t incoming, RobotStatus *status);

/**
 * This enum enumerates all different operations that can be sent to the robot.
 */
enum RobotOp
{
	ROBOT_NOOP = 0b000,
	ROBOT_LEFT = 0b001,
	ROBOT_RIGHT = 0b010,
	ROBOT_FORWARD = 0b011,
	ROBOT_STOP = 0b100
};

typedef enum RobotOp RobotOp;

/**
 * Returns the address of the string representation of the given operation.
 *
 * The returned string is of the format `<NAME> // <OPCODE>`.
 */
char *opName(RobotOp op);

/**
 * Places the given operation in the operations queue.
 */
void queueOp(RobotOp op);

/**
 * Returns the next operation that is to be sent to the robot. If no operation
 * is currently queued, the function will return `ROBOT_NOOP`.
 */
RobotOp nextOp();

/**
 * Prints each operation that is currently queued.
 */
void showOpQueue();

#endif//EPO2_COMMUNICATION_H
