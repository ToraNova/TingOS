; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	32Bit Print functions
;
; chia_jason96@live.com
; -----------------------------------------


PRINT_STRING32:	
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
.10	mov al,[ebx]
	inc ebx				; increment al
	or al,al
	jz .20
	int BIOS_INT_DISP		;display the current char in AL		
	jmp .10
.20	ret

DEBUG_BRK32:
	push eax
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al, '#'
	int 0x10
	pop eax
	ret

PRINT_NLCR32:
	push eax
	mov ah, BIOS_OUT_TTYPUT 	; int 10/ah = 0eh -> scrolling teletype BIOS routine
	mov al, 13
	int BIOS_INT_DISP
	mov al, 10
	int BIOS_INT_DISP
	pop eax
	ret

PRINT_HEX32:

	push edx
	push ecx
	push ebx
	push eax

    	lea   ebx, [HEX2CHAR_LOOKUP32]
	
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

	pop eax
	pop ebx
	pop ecx
	pop edx

    	ret

; -------------------------
; Lookups
; -------------------------
HEX2CHAR_LOOKUP32:
	db "0123456789ABCDEF",0
