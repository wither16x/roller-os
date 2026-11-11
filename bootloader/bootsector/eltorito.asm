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
    ; put the stack at 0xf8000
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

    call check_lba_support
    mov si, msg1
    call print_str

    call read_sectors
    mov si, msg2
    call print_str

    jmp 0:0x1000

hang:
    hlt
    jmp hang

%include "display.inc"

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

    call check_lba_support

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

; Check if INT 0x13 extensions are supported so LBA can be used to read
; from disk.
; Fail:
;   FATAL
check_lba_support:
    push ax
    push bx
    push dx

    mov ah, 0x41
    mov bx, 0x55aa
    mov dl, [driveno]
    int 0x13
    jc .fail

    pop dx
    pop bx
    pop ax
    ret

.fail:
    mov si, .msg
    call print_str

    jmp hang

.msg db "INT 0x13 extensions not supported", 0

; Read sectors from disk using INT 0x13 extensions.
; Since some BIOSes don't support more than 127 sectors to transfer, keep
; AX at a value lower than 127.
; Fail:
;   FATAL
read_sectors:
    push ax
    push dx
    push si

    mov ax, [bi_boot_file_location]
    inc ax
    mov word [dap_addr], ax
    mov si, dap_start
    mov ah, 0x42
    mov dl, [driveno]
    int 0x13
    jc .fail

    pop si
    pop dx
    pop ax
    ret

.fail:
    mov si, .msg
    call print_str

    jmp hang

.msg db "Could not read from disk", 13, 10, 0

driveno db 0
msg0    db "Booted from drive 0x", 0
msg1    db "INT 0x13 extensions supported", 13, 10, 0
msg2    db "Loaded stage 2", 13, 10, 0
newline db 13, 10, 0

; Disk Access Packet
dap_start:
    dap_size        db 0x10
    dap_zero        db 0
    dap_count       dw 1
    dap_buf:
        dw 0x1000
        dw 0
    dap_addr:
        dd 0
        dd 0
dap_end:

times 2048 - ($ - $$) db 0