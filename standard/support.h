//-----------------------------------------
//
// TingOS Hobbyist Kernel
// 	Support function headers
//
// chia_jason96@live.com
//-----------------------------------------
#ifndef SUPPORT_H
#define SUPPORT_H

#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA	0x3D5

#define CUR_OFF_HIGH_B	14
#define CUR_OFF_LOW_B	15

#define WHITE_ON_BLACK 0x0f
#define YELLOW_ON_BLACK 0x0e
#define PURPLE_ON_BLACK 0x0d
#define RED_ON_BLACK 0x0c
#define LBLUE_ON_BLACK 0x0b
#define GREEN_ON_BLACK 0x0a
#define DBLUE_ON_BLACK 0x09
#define GREY_ON_BLACK 0x08
#define BLACK_ON_WHITE 0xf0

#define DEBUG_START 1081

void idlewait(); //time wasting delay

#endif
