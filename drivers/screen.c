//-----------------------------------------
// 
// TingOS Hobbyist Kernel
// 	Screen display implementations
//
// chia_jason96@live.com
//-----------------------------------------
#include "screen.h"
#include "io.h"

unsigned int get_char_cell(unsigned int n){
	//get the nth char cell
	return 2*n;
}

unsigned int get_attr_cell(unsigned int n){
	//get the nth attr cell
	return 2*n+1;
}

unsigned int get_screen_offset(unsigned int col,unsigned int row){
	//get the offset to write on the memory array
	return (row*MAX_COLS + col)*2+1;
}

void drawFull(char target,char attr,unsigned int nrow){
	//draws a full line of 'target' with attribute 'attr' on the n-1th row.
	char *video_memory = (char*) 0xb8000; //video memory
	unsigned int rc;
	for(rc=0;rc<nrow*MAX_COLS;rc++){
		video_memory[get_char_cell(rc)+1] = target;
		video_memory[get_attr_cell(rc)+1] = attr;
	}
}

void rawPut(char target, char attr, unsigned int col, unsigned int row){
	//puts a single char with target and attr on a col-1 and row-1 position.
	char *video_memory = (char*) 0xb8000; //video memory
	video_memory[get_screen_offset(col,row)] = target;
	video_memory[get_screen_offset(col,row)+1] = attr;
}

unsigned int get_cursor(){
	port_byte_out ( REG_SCREEN_CTRL , CUR_OFF_HIGH_B);
	unsigned int offset = port_byte_in (REG_SCREEN_DATA) << 8;
	port_byte_out ( REG_SCREEN_CTRL , CUR_OFF_LOW_B);
	offset += port_byte_in ( REG_SCREEN_DATA );
	return offset*2;
}

void set_cursor(unsigned int offset){
	offset /= 2;
	port_byte_out ( REG_SCREEN_CTRL , CUR_OFF_HIGH_B);
	port_byte_out(REG_SCREEN_DATA,(unsigned char)(offset << 8));
	port_byte_out ( REG_SCREEN_CTRL , CUR_OFF_LOW_B);
	port_byte_out(REG_SCREEN_DATA,(unsigned char)offset);
}

void increment_cursor(){
	set_cursor(get_cursor()+2);
}

void decrement_cursor(){
	set_cursor(get_cursor()-2);
}

void printchar(char in,int col, int row, char attr){
	int offset;
	unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;
	
	if(!attr)attr=WHITE_ON_BLACK;
	
	if(col >=0 && row >= 0){
		offset = get_screen_offset(col,row);
	}else{
		offset = get_cursor();
	}

	if( in == '\n' ){
		int rows = offset / (2*MAX_COLS);
		offset = get_screen_offset(MAX_COLS-1,rows);
	}else{
		vidmem[offset] = in;
		vidmem[offset+1] = attr;
	}
	offset += 2;
	//offset = handle_scrolling(offset);
	set_cursor(offset);
}

