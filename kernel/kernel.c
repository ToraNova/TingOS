
//-----------------------------------------
// Main Kernel
// TingOS Hobbyist Kernel
// 	MAIN KERNEL
//
// chia_jason96@live.com
//-----------------------------------------

//int _start()
#include "screen.h"
#include "io.h"
#include "support.h"

#define TESTVAL 0x0003
void _start(){

	rawPut('X', RED_ON_BLACK, 79, 24);
	drawFull('Y', GREEN_ON_BLACK, 23);
	drawFull('K', GREEN_ON_BLACK, 22);
	idlewait(4000);
	drawFull('P', DBLUE_ON_BLACK, 21);
	idlewait(4000);
	clearScreen();
	//rawPut('Y', RED_ON_BLACK, 78, 24);
	//drawFull(' ', GREEN_ON_BLACK, 23);
	while(1){};
}
/*
void debugprint(int bit16int,char *videomem){
	const char hexlookup[16]= {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
	//displays at the location 819
	char lo = (char)(bit16int & 0x00ff);
	char hi = (char)((bit16int & 0xff00) >> 8);

	char lolon = lo & 0x0f;
	char lohin = (lo & 0xf0) >> 4;

	char hilon = hi & 0x0f;
	char hihin = (hi & 0xf0) >> 4;

	lolon = hexlookup[lolon+2];
	lohin = hexlookup[lohin+1];
	hilon = hexlookup[hilon+1];
	hihin = hexlookup[hihin+1];

	videomem[DEBUG_START] = hihin;
	videomem[DEBUG_START+2] = hilon;
	videomem[DEBUG_START+4] = lohin;
	videomem[DEBUG_START+6] = lolon;
}
*/
