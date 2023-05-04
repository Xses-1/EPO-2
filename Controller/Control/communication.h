//
// Created by Thijs J.A. van Esch on 4-5-2023.
//

#ifndef EPO2_COMMUNICATION_H
#define EPO2_COMMUNICATION_H

#include <stdbool.h>
#include <stdint.h>

struct SensorData
{
	bool left;
	bool middle;
	bool right;
};

typedef struct SensorData SensorData;

struct RobotStatus
{
	bool mineDetected;
	bool isDriving;
	bool isTurning;
	bool isMakingUTurn;
};

typedef struct RobotStatus RobotStatus;

/**
 * Parses the given data and writes the obtained values to the structs located
 * at the given addresses.
 *
 * The function assumes that it may write to these addresses.
 *
 * The function returns 1 if no data is available. If this is the case, nothing
 * will be written to the given addresses.
 */
int parseIncomingData(uint8_t incoming,
		      SensorData *sensorData,
		      RobotStatus *robotStatus);

#endif//EPO2_COMMUNICATION_H
