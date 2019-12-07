int_timer:
    pushad
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    inc dword [TIMER_COUNT]

    outp 0x20, 0x20

    pop es
    pop ds
    popad

    iret


align 4, db 0
TIMER_COUNT: dq 0
