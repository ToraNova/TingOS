; -----------------------------------------
; Boot sector
; TingOS Hobbyist Kernel
;	UTIL MODULE FOR DISK ASM
;
; chia_jason96@live.com
; -----------------------------------------

; -----------------------------------------
; BIOS function defines
; -----------------------------------------
BIOS_INP_DSECRD	equ	0x02		; disk sector read function
BIOS_INT_READ	equ	0x13 		; this interrupt causes the actual read subroutine

; ------------------------------------------
; disk read DH  sectors  to ES:BX from  drive  DL (Nick Blundell)
; ------------------------------------------
LOAD_DISK:
	push dx           			; Store DX on stack so  later we can recall
						; how many  sectors  were request to be read,
						; even if it is  altered in the meantime
	mov ah, 0x02     			; BIOS read sector function
	mov al, dh       			; Read DH sectors
	mov ch, 0x00     			; Select cylinder 0
	mov dh, 0x00     			; Select head 0
	mov cl, 0x02     			; Start reading from second sector (i.e.
						; after the boot sector)
	int 0x13          			; BIOS interrupt

	jc  ERROR_DISK    			; Jump if error (i.e. carry flag set)
	pop dx            			; Restore DX from the stack
	cmp dh, al       			; if AL (sectors read) != DH (sectors expected)
	jne  ERROR_DISK   			; display error message

	mov bx,STRING_DK_SUC
	call PRINT_STRING

	ret

; ------------------------------------
; Error handling
; ------------------------------------
ERROR_DISK:
	mov bx,STRING_DK_ERR
	call PRINT_STRING
	jmp $

STRING_RD_MSG:	db 'Attempting to read from disk 0...',13,10,0
STRING_DK_ERR:	db 'Disk read error !...',13,10,0
STRING_DK_SUC:	db 'Disk read successful !...',13,10,0

;mov bx,DISK_READ_BREG		; load DISK_READ_SECT sectors to 0x0000:DISK_READ_BREG(BX)
;mov dh,DISK_READ_SECT		; from the boot disk
;mov dl,[BOOT_DRIVE]
;call LOAD_DISK	

