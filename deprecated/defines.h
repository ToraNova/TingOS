//-----------------------------------------
// 
// TingOS Hobbyist Kernel
// 	Global define file
//
// chia_jason96@live.com
//-----------------------------------------
#ifndef DEFINES_H
#define DEFINES_H

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 82

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA	0x3D5

#define CUR_OFF_HIGH_B	14
#define CUR_OFF_LOW_B	15

#define WHITE_ON_BLACK 0x0f
#define RED_ON_BLACK 0x0e

#define DEBUG_START 1081

#endif
