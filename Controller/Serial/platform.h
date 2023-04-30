//
// Created by Thijs J.A. van Esch on 30-4-23.
//

//
// This file sets the 'WINDOWS' macro to either '1' or '0', depending on
//  whether application is being compiled for Windows or for Linux.
//
// If the program is being compiled for MacOS, the compiler will display an
//  error, since the functions in 'Serial/serial.h' are only defined for Linux
//  and Windows.
//

#ifndef EPO2_PLATFORM_H
#define EPO2_PLATFORM_H

#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)
#	define WINDOWS 1
#elif __APPLE__
#	error "interface in Serial/serial.h is not implemented for MacOS"
#elif __linux__
# 	define WINDOWS 0
#endif

#endif //EPO2_PLATFORM_H
