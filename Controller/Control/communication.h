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

#endif//EPO2_COMMUNICATION_H
