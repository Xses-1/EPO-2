//
// Created by Thijs J.A. van Esch on 30-4-23.
//

//
// This is a simple test I wrote to test the Linux implementation of the
//  serial communication interface. I have programmed an Arduino to simply
//  return whatever is written to it over a serial connection. The code running
//  the Arduino has been verified manually using the GNU Screen terminal
//  multiplexer. This test simply writes characters to the Arduino and checks
//  whether the data the Arduino writes back is the same.
//

#include <stdio.h>
#include <stdlib.h>

#include "../Serial/serial.h"

void rwTest(uint8_t data)
{
	writeByte(&data);
	uint8_t *in = (uint8_t *) malloc(sizeof(uint8_t));
	readByte(in);
	if (*in != data)
	{
		printf("Data mismatch: expected %c, got %c\n", data, *in);
	} else
	{
		printf("Success: expected %c, got %c\n", data, *in);
	}
	free(in);
}

void rwLong(const uint8_t *data, size_t length)
{
	writeData(data, length);
	uint8_t *in = (uint8_t *) malloc(sizeof(uint8_t) * length);
	readData(in, length);
	for (int i = 0; i < length; ++i)
	{
		if (*(in + i) != *(data + i))
		{
			printf("Data mismatch: expected %c, got %c\n",
			       *(data + i), *(in + i));
		} else
		{
			printf("Success: expected %c, got %c\n",
			       *(data + i), *(in + i));
		}
	}
	free(in);
}

int main()
{
	int error;
	error = initSio();
	if (error)
	{
		printf("\nUnable to initialize serial interface (%d)\n",
		       error);
		return 1;
	}
	uint8_t *testData = (uint8_t *) malloc(sizeof(uint8_t) * 26);
	for (int i = 'a'; i < 'z'; ++i)
	{
		rwTest((uint8_t) i);
		*(testData + (i - 'a')) = i;
		rwLong(testData, i - 'a' + 1);
	}
	free(testData);
	closeSio();
	return 0;
}
