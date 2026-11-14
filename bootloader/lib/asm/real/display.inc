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

; Displays a nibble using base 16 on the screen.
; Input:
;   BL: value
;   BH (optional): page
print_hex_nibble:
    push ax
    push bx
    push cx

    mov ah, 0x0e
    cmp bl, 10
    jl .is_num
    jmp .is_char

.is_num:
    mov al, bl
    add al, '0'
    jmp .end

.is_char:
    mov al, bl
    sub al, 10
    add al, 'a'

.end:
    int 0x10

    pop cx
    pop bx
    pop ax
    ret

; Displays a byte using base 16 on the screen.
; Input:
;   BL: value
;   BH (optional): page
print_hex_byte:
    push bx

    push bx
    shr bx, 4
    call print_hex_nibble
    pop bx
    and bx, 15
    call print_hex_nibble

    pop bx
    ret

; Displays a word using base 16 on the screen.
; Input:
;   BL: value
;   BH (optional): page
print_hex_word:
    push bx

    push bx
    shr bx, 8
    call print_hex_byte
    pop bx
    and bx, 255
    call print_hex_byte

    pop bx
    ret

%endif ; ASM_REAL_DISPLAY_INC_