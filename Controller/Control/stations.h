//
// Created by Thijs J.A. van Esch on 10-5-23.
//

#ifndef EPO2_STATIONS_H
#define EPO2_STATIONS_H

/**
 * Writes the location for the given station to the given addresses. This
 * location is determined from the given station identifier, which must be in
 * the range [1, 12]. If a value is given that is not in this range, an error
 * will be printed to the console.
 *
 * It is assumed that the function may write to the given addresses.
 */
void getStationLocation(int station, int *row, int *col);

#endif//EPO2_STATIONS_H
