//
// Created by Thijs J.A. van Esch on 30-4-23.
//

#include "params.h"
#include "serial.h"

#if WINDOWS

//
// The Windows implementation of the functions declared in serial/serial.h
//  are defined below.
//

int initSio()
{
	return 0;
}

int readData(uint8_t *data, size_t bytes)
{
	return 0;
}

int writeData(const uint8_t *data, size_t bytes)
{
	return 0;
}

int closeSio()
{
	return 0;
}

#else

//
// The Linux implementation of the functions declared in serial/serial.h
//  are defined below.
//
// If working on/for Windows, ignore everything below this comment.
//

int initSio()
{
	return 0;
}

int readData(uint8_t *data, size_t bytes)
{
	return 0;
}

int writeData(const uint8_t *data, size_t bytes)
{
	return 0;
}

int closeSio()
{
	return 0;
}

#endif

//
// The implementations of these functions are the exact same for both Windows
//  and Linux, so they go here.
//

int readByte(uint8_t *byte)
{
	return readData(byte, 1);
}

int writeByte(const uint8_t *byte)
{
	return writeData(byte, 1);
}
