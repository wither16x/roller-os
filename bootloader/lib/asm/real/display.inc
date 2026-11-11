%ifndef ASM_REAL_DISPLAY_INC_
%define ASM_REAL_DISPLAY_INC_

; Displays a null-terminated string on the screen.
; Input:
;   SI: pointer to the string
;   BH (optional): page
print_str:
    push ax
    push bx
    push si

    mov ah, 0xe

.next:
    lodsb

    test al, al
    jz .end

    int 0x10

    jmp .next

.end:
    pop si
    pop bx
    pop ax
    ret

%endif ; ASM_REAL_DISPLAY_INC_