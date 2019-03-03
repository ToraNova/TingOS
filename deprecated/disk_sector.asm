; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	MAIN DISK SECTOR CODE
;
; chia_jason96@live.com
; -----------------------------------------

; ------------------------------------------------------------------
; Beginning of disk sector ( Sector 2 ) (on CODE_SEGMENT:DISK_READ_BREG)
; ------------------------------------------------------------------
DISK_SECTOR_BEGIN:
	call DEBUG_BRK
	call SWITCH_PM

DEBUG_BRK:
	push ax
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al, '#'
	int 0x10
	pop ax
	ret

%include "gdt.asm"			; global descriptor table defines

SWITCH_PM:
	
	cli				; clear interrupts
	lgdt [GDT_DESCRIPTOR]		; load the global descriptor table descriptor
	mov eax , cr0    		; To make  the  switch  to  protected  mode , we set
	or eax , 0x1     		; the  first  bit of CR0 , a control  register
	mov cr0 , eax    		; Update  the  control  register
	jmp $
	jmp 0x0000:PROTECTED_MODE 	; Make a far  jump (i.e. to a new  segment) to our 32-bit
					; code.   This  also  forces  the  CPU to  flush  its  cache  of
					; pre -fetched  and real -mode  decoded  instructions , which  can
					; cause  problems.

[bits 32]
PROTECTED_MODE:
	mov ax, DATA_SEG         	; Now in PM, our  old  segments  are  meaningless ,
	mov ds, ax                	; so we  point  our  segment  registers  to the
	mov ss, ax                	; data  selector  we  defined  in our  GDT
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp , 0x90000         	; Update  our  stack  position  so it is  right
	mov esp , ebp            	; at the  top of the  free  space.

	jmp $
	;mov eax,STRING_PM_DIS
	;call PRINT_HEX32

	jmp $

;%include "s2-s11/print_utils32.asm"


; --------------------------------------------------------------------------------------------------
; Data string (inclusive of newline and carriage return. with 0 as terminator)
; --------------------------------------------------------------------------------------------------
STRING_PM_DIS:	db 'Currently in Protected mode (32bits)...',13,10,0

