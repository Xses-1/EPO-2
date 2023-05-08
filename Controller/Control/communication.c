//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#include "communication.h"

void parseRobotStatus(uint8_t incoming, RobotStatus *robotStatus)
{
	robotStatus->isMakingUTurn = incoming & (1 << 7) ? 1 : 0;
	robotStatus->isTurning = incoming & (1 << 6) ? 1 : 0;
	robotStatus->isDriving = incoming & (1 << 5) ? 1 : 0;
	robotStatus->leftLine = incoming & (1 << 4) ? 1 : 0;
	robotStatus->middleLine = incoming & (1 << 3) ? 1 : 0;
	robotStatus->rightLine = incoming & (1 << 2) ? 1 : 0;
	robotStatus->mineDetected = incoming & (1 << 1) ? 1 : 0;
}

bool parseIncomingData(uint8_t incoming, RobotStatus *robotStatus)
{
	if (!(incoming & 1))
	{
		return true;
	}
	parseRobotStatus(incoming, robotStatus);
	return false;
}
