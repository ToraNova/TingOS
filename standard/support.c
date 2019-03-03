//-----------------------------------------
//
// TingOS Hobbyist Kernel
// 	Support functions implementations
//
// chia_jason96@live.com
//-----------------------------------------
#include "support.h"

void idlewait(unsigned long cycles){
	// 5000 cycles with 1000,000 T1 loop approx to 7 seconds delay
	// 5,000,000,000 cycles -> 7 seconds

	while(cycles > 0){
		unsigned long t1 = 1000000;
		while(t1 > 0){
			t1 --;
		}
		cycles--;
	}
}
