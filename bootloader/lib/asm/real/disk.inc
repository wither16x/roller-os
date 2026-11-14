%ifndef ASM_REAL_DISK_INC_
%define ASM_REAL_DISK_INC_

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

%endif ; ASM_REAL_DISK_INC_