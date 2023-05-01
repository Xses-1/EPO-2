//
// Created by Thijs J.A. van Esch on 1-5-2023.
//

#include "../Serial/serial.h"

#include <stdlib.h>
#include <stdio.h>

uint16_t MAX_CHARS = 500;

void printInput()
{
	uint16_t chars = 0;
	uint8_t input;
	while (1)
	{
		input = 0;
		readByte(&input);
		if (input)
		{
			printf("%c", input);
			chars++;
		}
		if (chars >= MAX_CHARS)
		{
			return;
		}
	}
}

void writeOutput()
{
	uint16_t chars = 0;
	uint8_t *output = (uint8_t *) malloc(sizeof(uint8_t) * 100);
	printf("Type strings to send over the serial interface.\n");
	while (1)
	{
		printf("> ");
		scanf("%s", output);
		int index = 0;
		while (*(output + index++));
		int error = writeData(output, index);
		if (error)
		{
			printf("An error occurred: %d\n", error);
		} else
		{
			printf("Send string '%s' (length %d)\n",
			       output, index);
		}
		if (chars >= MAX_CHARS)
		{
			break;
		}
	}
	free(output);
}

int main()
{
	int error;
	error = initSio();
	if (error)
	{
		printf("an error occurred during serial initialization (%d)",
		       error);
		return 1;
	}
	// printInput();
	writeOutput();
	return 0;
}
