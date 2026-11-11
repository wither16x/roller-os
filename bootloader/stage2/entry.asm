BITS 16
ORG 0x1000

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call print_str

hang:
    hlt
    jmp hang

%include "display.inc"

msg db "Hello from stage 2!", 0

times 2048 - ($ - $$) db 0