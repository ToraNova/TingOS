; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	SWITCH MODULE FOR PM
;
; chia_jason96@live.com
; -----------------------------------------

[bits  16]	
	
SWITCH_PM:			; Switch  to  protected  mode
	cli             	; We must  switch  of  interrupts  until  we have
				; set -up the  protected  mode  interrupt  vector
				; otherwise  interrupts  will  run  riot.
	lgdt [GDT_DESCRIPTOR]   ; Load  our  global  descriptor  table , which  defines
				; the  protected  mode  segments (e.g.  for  code  and  data)
	mov eax , cr0           ; To make  the  switch  to  protected  mode , we set
	or eax , 0x1            ; the  first  bit of CR0 , a control  register
	mov cr0 , eax
	
	jmp  CODE_SEG:INIT_PM	; Make a far  jump (i.e. to a new  segment) to our 32-bit
				; code.   This  also  forces  the  CPU to  flush  its  cache  of
				; pre -fetched  and real -mode  decoded  instructions , which  can
				; cause  problems.
[bits  32]
			
INIT_PM:			; Initialise  registers  and  the  stack  once in PM.

	mov ax, DATA_SEG        ; Now in PM, our  old  segments  are  meaningless ,
	mov ds, ax              ; so we  point  our  segment  registers  to the
	mov ss, ax              ; data  selector  we  defined  in our  GDT
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp , 0x90000       ; Update  our  stack  position  so it is  right
	mov esp , ebp           ; at the  top of the  free  space.
	
	jmp  PROTECTED_MODE     ; Finally , call  some well -known  label
