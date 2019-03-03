; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	MAIN BOOT SECTOR CODE _T3
;
; chia_jason96@live.com
; -----------------------------------------

; -----------------------------------------
; Boot sector important macros
; -----------------------------------------
BOOTSECT_TERM_N	equ 	0xaa55		; boot sector terminating magic number (BS must terminate with this)
BOOTSECT_SIZE	equ 	512		; 512 bytes for the bootsector
BOOTSECT_SIZE_W equ	BOOTSECT_SIZE-2 ; 2 bytes at the end reserved for BOOTSECT_TERM_N
BOOTSECT_BASE_A	equ	0x07c0		; BIOS bootsector base address

KERNEL_OFFSET	equ	0x1000		; Kernel begins at 0x1000
LOAD_K_S_READ	equ	15

BIOS_OUT_TTYPUT equ	0x0e		; BIOS teletype scrolling switch
BIOS_INT_DISP	equ	0x10		; BIOS interrupt putchar subroutine

[org 0x7c00]
[bits 16]
BOOTS_MAIN:
	mov [BOOT_DRIVE], dl 		; BIOS stores our boot drive in DL
	mov bp,0x9000			; stack pointer setup (base pointer)
	mov sp,bp			; stack setup

	mov bx,STRING_OS_VER
	call BS_PRINT_STR
	mov bx,STRING_RM_DIS
	call BS_PRINT_STR
	
	call LOAD_KERNEL
	mov ax,[KERNEL_OFFSET]
	call PRINT_HEX
	mov ax,[KERNEL_OFFSET+2]
	call PRINT_HEX
	jmp SWITCH_PM

; ------------------------------------
; Simple display 16bits
; ------------------------------------
BS_PRINT_STR:	
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
.10	mov al,[bx]
	inc bx				; increment al
	or al,al
	jz .20
	int BIOS_INT_DISP		;display the current char in AL		
	jmp .10
.20	ret

; ------------------------------------
; Simple hex display subroutine (PARAM stored in AX 16bit)
; ------------------------------------
HEX2CHAR_LOOKUP:
	db "0123456789ABCDEF",0
PRINT_HEX:

	push dx
	push cx
	push bx
	push ax

    	lea   bx, [HEX2CHAR_LOOKUP]
	
	mov dx,ax

	;AL operation
    	mov ah, al            		; make al and ah equal so we can isolate each half of the byte
    	shr ah, 4             		; ah now has the high nibble
    	and al, 0x0F          		; al now has the low nibble
    	xlat                    	; lookup al's contents in our table
    	xchg ah, al            		; flip around the bytes so now we can get the higher nibble 
    	xlat                    	; look up what we just flipped

	mov cx,ax			; 2 chars on cx now for LOWER BYTE
	
	;AH operation
	mov ax,dx
	mov al, ah            		; make al and ah equal so we can isolate each half of the byte
    	shr ah, 4             		; ah now has the high nibble
    	and al, 0x0F          		; al now has the low nibble
    	xlat                    	; lookup al's contents in our table
    	xchg ah, al            		; flip around the bytes so now we can get the higher nibble 
    	xlat                    	; look up what we just flipped

	mov dx,ax			; 2 chars on dx now for HIGHER BYTE		
	
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al,dl
	int BIOS_INT_DISP
	mov al,dh
	int BIOS_INT_DISP

	mov al,cl
	int BIOS_INT_DISP
	mov al,ch
	int BIOS_INT_DISP
	
	mov al,' '
	int BIOS_INT_DISP

	pop ax
	pop bx
	pop cx
	pop dx

    	ret

; --------------------------------------------------------------------------------------------------
; Data string (inclusive of newline and carriage return. with 0 as terminator)
; --------------------------------------------------------------------------------------------------
STRING_OS_VER:	db 'TingOS version 1.00_t3',13,10,0	
STRING_RM_DIS:	db 'Currently in Real mode (16bits)...',13,10,0
STRING_KN_LDM:	db 'Loading the kernel...',13,10,0
BOOT_DRIVE db 0

; ------------------------------------
; Important Includes
; ------------------------------------
%include "boot/disk_utils.asm"
%include "boot/gdt.asm"
%include "boot/protected_switch.asm"

[bits  16]

LOAD_KERNEL:				; load_kernel
	mov bx, STRING_KN_LDM    	; Print a message to say we are loading the kernel
	call  BS_PRINT_STR
	mov bx, KERNEL_OFFSET      	; Set-up parameters for our disk_load routine , so
	mov dh, LOAD_K_S_READ           ; that we load the first 5 sectors (excluding
	mov dl, [BOOT_DRIVE]       	; the boot sector) from the boot disk (i.e.  our
	call  LOAD_DISK               	; kernel code) to address KERNEL_OFFSET
	ret

[bits 32]

	
PROTECTED_MODE:				; This is  where we  arrive  after  switching  to and  initialising  protected  mode.
	mov ebx , 0x00

	call KERNEL_OFFSET		; launch the kernel
	jmp $				; FINAL BLOCK

; ------------------------------------
; End of a boot sector contains 0xaa55
; ------------------------------------
times BOOTSECT_SIZE_W-($-$$) db 0 	;padding of 0 to the end of sector

dw BOOTSECT_TERM_N			;magic number to indicate THIS is a boot sector

; --------------------------------------------------------------------------------------------------
; END OF BOOT SECTOR, THE FOLLOWING ARE DISK SECTORS ;ENTRANCE POINT OF <jmp 0x0000:DISK_READ_BREG>
; --------------------------------------------------------------------------------------------------



