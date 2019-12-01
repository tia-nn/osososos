%include "src/includes/constant.d.s"
%include "src/includes/struct.d.s"
%include "src/includes/macro.m.s"

BITS 16

ORG BOOT_LOAD

jmp ipl

bpb:
    times 90 - ($ - $$) db 0x90  ; nop

ipl:
stage_1:
.text_section:
    cli
        ; set segment register
        mov ax, 0
        mov ds, ax
        mov es, ax
        mov ss, ax

        ; set stack flame to BOOT_LOAD
        mov bp, BOOT_LOAD
        mov sp, bp
    sti

    ; set drive number
    mov [BOOT + Drive.no], dl

    ; put boot messgae
    ccall puts, .boot_message

    ; read 2~ stage serctor
    mov bx, BOOT_SECT - 1
    mov cx, BOOT_LOAD + SECT_SIZE
    ccall drive_read_chs, BOOT, bx, cx

    cmp ax, bx
    je .10E
        ccall puts, .error_message
        call reboot
    .10E:

    jmp stage_2


.data_section:

    .boot_message: db "Hello, World!", 10, 13, 0
    .error_message: db " Cannot read sector", 10, 13, 0

align 2, db 0

BOOT:
    istruc Drive
        at Drive.no, dw 0
        at Drive.cyln, dw 0
        at Drive.head, dw 0
        at Drive.sect, dw 2
    iend

%include "src/modules/real/puts.s"
%include "src/modules/real/drive_read_chs.s"
%include "src/modules/real/reboot.s"

times 510 - ($ - $$) db 0
db 0x55, 0xaa

; ========= end boot sector ==========

FONT:
    istruc Addr
        at Addr.seg, dw 0
        at Addr.addr, dw 0
    iend

ACPI_DATA:
    .addr: dd 0
    .len: dd 0

stage_2:
.text_section:

    ccall puts, .enter_message

    ccall drive_get_param, BOOT

    test ax, ax
    jnz .10E
        ccall puts, .error_message
        call reboot
    .10E:

    ccall itoa, word [BOOT + Drive.no], .p1, 2, 16, 0b0100
    ccall itoa, word [BOOT + Drive.cyln], .p2, 4, 16, 0b0100
    ccall itoa, word [BOOT + Drive.head], .p3, 2, 16, 0b0100
    ccall itoa, word [BOOT + Drive.sect], .p4, 2, 16, 0b0100
    ccall puts, .drive_state_str

    jmp stage_3


.data_section:

    .enter_message: db "2nd stage.", 10, 13, 0
    .error_message: db " Cannot read drive states.", 10, 13, 0
    .drive_state_str:
                db " Boot Drive Info:", 10, 13
                db '    Drive No.: 0x'
        .p1:    db '--', 10, 13
                db '    Cylinder: 0x'
        .p2:    db '----', 10, 13
                db '    Hader: 0x'
        .p3:    db '--', 10, 13
                db '    Sector: 0x'
        .p4:    db '--', 10, 13, 0

%include "src/modules/real/drive_get_param.s"
%include "src/modules/real/itoa.s"


stage_3:
.text_section:
    
    ccall puts, .enter_message

    ccall get_font_addr, FONT

    ccall itoa, word [FONT + Addr.seg], .p1, 4, 16, 0b0100
    ccall itoa, word [FONT + Addr.addr], .p2, 4, 16, 0b0100
    ccall puts, .font_addr_str

    call get_mem_info

    mov eax, [ACPI_DATA.addr]
    test eax, eax
    jz .10E
        ccall itoa, ax, .p4, 4, 16, 0b0100
        shr eax, 16
        ccall itoa, ax, .p3, 4, 16, 0b0100
        ccall puts, .acpi_data_str
    .10E:

    jmp stage_4


.data_section:

    .enter_message: db "3rd stage.", 10, 13, 0
    .font_addr_str:
                db " Font address = "
        .p1:    db "----"
                db ":"
        .p2:    db "----"
                db 10, 13, 0
    .acpi_data_str:
                db " ACPI Data = "
        .p3:    db "----"
        .p4:    db "----"
                db 10, 13, 0

%include "src/modules/real/get_font_addr.s"
%include "src/modules/real/get_mem_info.s"


stage_4:
.text_section:

    ccall puts, .enter_message

    cli
        ; set A20 gate
        ccall KBC_cmd_write, KBC_CMD_KEYBOARD_DISABLE
        
        ccall KBC_cmd_write, KBC_CMD_READ_OUTPUTPORT
        ccall KBC_data_read, .key

        mov ax, [.key]
        or ax, 0x00000010  ; A20 gate enable

        ccall KBC_cmd_write, KBC_CMD_WRITE_OUTPUTPORT
        ccall KBC_data_write, ax

        ccall KBC_cmd_write, KBC_CMD_KEYBOARD_ENABLE

    sti

    ccall puts, .a20_message

    jmp stage_5


.data_section:

    .enter_message: db "4th stage.", 10, 13, 0
    .a20_message:   db " A20 Gate enabled.", 10, 13, 0
    .key: dw 0

%include "src/modules/real/kbc.s"


stage_5:
.text_section:

    ccall puts, .enter_message

    ccall drive_read_lba, BOOT, BOOT_SECT, KERNEL_SECT, BOOT_END

    cmp ax, KERNEL_SECT
    je .10E
        ccall puts, .error_message
        call reboot
    .10E:

    ccall puts, .done_message

    jmp stage_6


.data_section:

    .enter_message: db "5th stage.", 10, 13, 0
    .error_message: db " Failure load kernel.", 10, 13, 0
    .done_message: db " kernel loaded.", 10, 13, 0
    .chs: times Drive_size db 0

%include "src/modules/real/drive_lba2chs.s"
%include "src/modules/real/drive_read_lba.s"


stage_6:
.text_section:

    ccall puts, .enter_message

    .10L:
        mov ah, 0x00
        int 0x16
        cmp al, ' '
        jne .10L
    
    mov ax, 0x0012
    int 0x10  ; ビデオモード変更

    .END:
        hlt
        jmp .END


.data_section:

    .enter_message: db "6th stage.", 10, 13
                    db 10, 13, " [Push SPACE key to protect mode.]", 10, 13, 0
    

times BOOT_SIZE - ($ - $$) db 0
