//
// Created by Thijs J.A. van Esch on 30-4-23.
//

#ifndef EPO2_PARAMS_H
#define EPO2_PARAMS_H

#include "platform.h"

#if WINDOWS
# 	define BAUD CBR_9600
# 	define BYTESIZE 8
#	define PARITY NOPARITY
# 	define STOPBITS ONESTOPBIT
#	define PORT "COM3"
#else
#	define BAUD B9600
# 	define BYTESIZE 8
#	define PARITY 0
# 	define STOPBITS 0
#	define PORT "/dev/ttyUSB0"
#endif

#endif //EPO2_PARAMS_H
