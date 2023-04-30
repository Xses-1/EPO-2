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
// Most of the Linux-specific code in this file is adapted from an answer to
//  a question on stackoverflow, which can be found here:
//
//  https://stackoverflow.com/questions/6947413
//     /how-to-open-read-and-write-from-serial-port-in-c
//
//

#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>

//
// This is the handle for the serial communication.
//
// Its default value is INT32_MIN. The file descriptor will be set from within
//  the `initSio()` function.
//
int fd = INT32_MIN;

void formatTermios(struct termios *tty)
{
	tty->c_cflag = (tty->c_cflag & ~CSIZE) | CS8;
	tty->c_iflag &= ~IGNBRK;
	tty->c_lflag = 0;
	tty->c_oflag = 0;
	tty->c_cc[VMIN] = 0;
	tty->c_cc[VTIME] = 5;
	tty->c_iflag &= ~(IXON | IXOFF | IXANY);
	tty->c_cflag |= (CLOCAL | CREAD);
	tty->c_cflag &= ~(PARENB | PARODD);
	tty->c_cflag |= PARITY;
	tty->c_cflag &= ~CSTOPB;
	tty->c_cflag &= ~CRTSCTS;
}

int setInterfaceAttributes()
{
	struct termios tty;
	if (tcgetattr(fd, &tty) != 0)
	{
		printf("error %d from tcgetattr", errno);
		return -1;
	}
	cfsetospeed(&tty, BAUD);
	cfsetispeed(&tty, BAUD);
	formatTermios(&tty);
	if (tcsetattr(fd, TCSANOW, &tty) != 0)
	{
		printf("error %d from tcsetattr", errno);
		return -1;
	}
	return 0;
}

void setBlocking()
{
	struct termios tty;
	memset(&tty, 0, sizeof tty);
	if (tcgetattr(fd, &tty) != 0)
	{
		printf("error %d from tggetattr", errno);
		return;
	}
	tty.c_cc[VMIN] = 0;
	tty.c_cc[VTIME] = 5;
	if (tcsetattr(fd, TCSANOW, &tty) != 0)
	{
		printf("error %d setting term attributes", errno);
	}
}

int initSio()
{
	if (fd != INT32_MIN)
	{
		/* if the interface has already been initialized
		    -> return */
		return 0;
	}
	fd = open(PORT, O_RDWR | O_NOCTTY | O_SYNC);
	if (fd < 0)
	{
		printf("error %d opening %s: %s", errno, PORT,
		       strerror(errno));
		return 1;
	}
	setInterfaceAttributes();
	setBlocking();
	return 0;
}

int readData(uint8_t *data, size_t bytes)
{
	if (fd == INT32_MIN)
	{
		/* attempting to read before interface initialization
		    -> return error code -11 */
		return -11;
	}
	read(fd, data, bytes);
	return 0;
}

int writeData(const uint8_t *data, size_t bytes)
{
	if (fd == INT32_MIN)
	{
		/* attempting to write before interface initialization
		    -> return error code -13 */
		return -13;
	}
	write(fd, data, bytes);
	return 0;
}

int closeSio()
{
	if (fd == INT32_MIN)
	{
		/* attempting to close connection before initialization
		    -> nothing to do; simply return */
		return 0;
	}
	return close(fd);
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
