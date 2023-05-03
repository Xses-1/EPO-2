//
// Created by Thijs J.A. van Esch on 30-4-23.
//

#include <stdlib.h>

#include "Serial/serial.h"
#include "Control/control.h"

int main(int argc, char **argv)
{
	PROGRAM_ARGS *args = (PROGRAM_ARGS *) malloc(sizeof(PROGRAM_ARGS));
	int error = parseArguments(argc, argv, args);
	if (error)
	{
		return error;
	}
	printArguments(args);
	return 0;
}
