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
%include "disk.inc"

driveno db 0
msg0    db "Booted from drive 0x", 0
msg1    db "INT 0x13 extensions supported", 13, 10, 0
msg2    db "Loaded stage 2", 13, 10, 0
newline db 13, 10, 0

times 2048 - ($ - $$) db 0