; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	UTIL MODULE FOR PRINT ASM
;
; chia_jason96@live.com
; -----------------------------------------

; -----------------------------------------
; BIOS function defines
; -----------------------------------------
BIOS_OUT_TTYPUT	equ	0x0e		; put this on AL to allow TTYPUT function
BIOS_INT_DISP	equ	0x10 		; call this interrupt when AH==OUT_TTYPUT

; ------------------------------------
; Simple display string subroutine (PARAM stored in BX)
; ------------------------------------
PRINT_STRING:	
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

; ------------------------------------------
; Newline and CR (Prints a newline and carriage return)
; ------------------------------------------
PRINT_NLCR:
	push ax
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al, 13
	int BIOS_INT_DISP
	mov al, 10
	int BIOS_INT_DISP
	pop ax
	ret

	

