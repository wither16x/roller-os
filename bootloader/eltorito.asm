; This is a x86 BIOS bootloader for El-Torito ISO images.

BITS 16
ORG 0x7c00

    jmp 0:start
    times 8 - ($ - $$) db 0

; Boot Information Table
    bi_primary_volume_descriptor        dd 0 ; LBA
    bi_boot_file_location               dd 0
    bi_boot_file_length                 dd 0
    bi_checksum                         dd 0
    bi_reserved                         times 40 db 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ax, 0x8000
    mov ss, ax
    mov sp, 0xf000

    mov [driveno], dl

    mov si, msg0
    call print_str
    mov bl, dl
    call print_hex_byte
    mov si, newline
    call print_str

hang:
    hlt
    jmp hang

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

driveno db 0
msg0    db "Booting from drive 0x", 0
newline db 13, 10, 0