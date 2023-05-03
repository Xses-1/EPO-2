//
// Created by Thijs J.A. van Esch on 3-5-23.
//

#include <stdio.h>
#include <stdlib.h>

#include "arguments.h"


const char *INSUFFICIENT_ARGS =
	"The proper way to assign program arguments is by using the following\n"
	"format:\n\n"
	""
	"[program] [start] [station, ...]\n\n"
	""
	"Where both `start` and all entries for `station` are integers that\n"
	"represent a station on the maze. At least one value has to be given\n"
	"for `station`.\n";

int parseArguments(int argc, char **argv, PROGRAM_ARGS *args)
{
	if (argc < 3)
	{
		printf("ERROR illicit number of arguments: %d\n\n", argc - 1);
		printf("%s", INSUFFICIENT_ARGS);
		return 1;
	}
	args->stations = (uint8_t *) malloc(sizeof(uint8_t) * argc - 2);
	args->n = (uint8_t) (argc - 2);
	for (int i = 1; i < argc; ++i)
	{
		char *arg = *(argv + i);
		uint8_t converted = (uint8_t) strtol(arg, NULL, 10);
		if (converted < 1 || converted > 12)
		{
			printf("illicit value for `%s`: %s\n",
			       i == 1 ? "start" : "station", arg);
			return 2;
		}
		if (i == 1)
		{
			args->start = converted;
		} else
		{
			*(args->stations + i - 2) = converted;
		}
	}
	return 0;
}

void printArguments(const PROGRAM_ARGS *args)
{
	printf("start:\t%d\n", args->start);
	for (int i = 0; i < args->n; ++i)
	{
		uint8_t station = *(args->stations + i);
		printf("st. %d:\t%d\n", i, station);
	}
	printf("\n");
}
