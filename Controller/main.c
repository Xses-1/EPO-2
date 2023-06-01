//
// Created by Thijs J.A. van Esch on 30-4-23.
//

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "Control/control.h"
#include "Serial/serial.h"

#ifndef PERIOD
#define PERIOD 50
#endif

void initialCycles()
{
	for (int i = 0; i < 10; ++i)
	{
		uint8_t in, out = 0;
		writeByte(&out);
		usleep(PERIOD * 1000);
		readByte(&in);
		usleep(PERIOD * 1000);
	}
}

void run()
{
	for (int i = 0; i < 500; ++i)
	{
		uint8_t in = 0;
		uint8_t out = 0b100;
		if (i >= 0 && i <= 200)
		{
			// out = 0b010;
			out = 0b011;
		}
		printf(" >>> iteration %d\n", i);
		if (out)
		{
			printf("     writing to robot: 0x%02x\n", out);
		}
		int error;
		error = writeByte(&out);
		if (error)
		{
			printf(" !!! write error (code %d)", error);
		}
		usleep(PERIOD * 1000);
		error = readByte(&in);
		printf("     received from robot: 0x%02x\n", in);
		if (error)
		{
			printf(" !!! read error (code %d)", error);
		}
		usleep(PERIOD * 1000);
	}
}

int main(int argc, char **argv)
{
	PROGRAM_ARGS *args = (PROGRAM_ARGS *) malloc(sizeof(PROGRAM_ARGS));
	int error;
	error = parseArguments(argc, argv, args);
	if (error)
	{
		return error;
	}
	error = initSio();
	if (error)
	{
		return error;
	}
	initialCycles();
	run();
	closeSio();
	return 0;
}
