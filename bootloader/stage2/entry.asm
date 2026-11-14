BITS 16
ORG 0x1000

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call print_str

    cli

    lgdt [gdt_ptr]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:init_protected_mode

hang:
    hlt
    jmp hang

%include "display.inc"

; Global Descriptor Table
gdt_start:

gdt_null:
    dq 0

gdt_code:
    dw 0xffff       ; limit low
    dw 0x0000       ; base low
    db 0x00         ; base mid
    db 10011010b    ; access: Present | Readable | Conforming | Executable | Code | DPL 0
                    ; | Available
    db 11001111b    ; limit | flags
    db 0x00         ; base high

gdt_data:
    dw 0xffff       ; limit low
    dw 0x0000       ; base low
    db 0x00         ; base mid
    db 10010110b    ; access: Present | Writable | Non-conforming | Non-executable | Data
                    ; | DPL 0 | Available
    db 11001111b    ; limit | flags
    db 0x00         ; base high

gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start

msg db "Hello from stage 2!", 0

BITS 32

init_protected_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0xf8000

    mov edi, 0xb8000
    mov word [edi], (0xf << 8) | 'A'

hang32:
    hlt
    jmp hang32

times 2048 - ($ - $$) db 0