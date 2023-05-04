//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#include "communication.h"

void parseSensorData(uint8_t incoming, SensorData *sensorData)
{
	sensorData->left = incoming & (1 << 3) ? 1: 0;
	sensorData->middle = incoming & (1 << 2) ? 1: 0;
	sensorData->right = incoming & (1 << 1) ? 1: 0;
}

void parseRobotStatus(uint8_t incoming, RobotStatus *robotStatus)
{
	robotStatus->isMakingUTurn = incoming & (1 << 7) ? 1: 0;
	robotStatus->isTurning = incoming & (1 << 6) ? 1: 0;
	robotStatus->isDriving = incoming & (1 << 5) ? 1: 0;
	robotStatus->mineDetected = incoming & (1 << 4) ? 1: 0;
}

int parseIncomingData(uint8_t incoming,
		      SensorData *sensorData,
		      RobotStatus *robotStatus)
{
	if (!(incoming & 1))
	{
		return 1;
	}
	parseSensorData(incoming, sensorData);
	parseRobotStatus(incoming, robotStatus);
	return 0;
}
