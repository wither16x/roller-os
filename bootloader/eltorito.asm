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
    mov ah, 0xe
    mov al, 'I'
    int 0x10
    mov ah, 0xe
    mov al, 'S'
    int 0x10
    mov ah, 0xe
    mov al, 'O'
    int 0x10

hang:
    hlt
    jmp hang