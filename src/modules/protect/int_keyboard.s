int_keyboard:
    pusha
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    in al, 0x60
    cdecl ringbuff_wr, _KEY_BUFF, eax

    outp 0x20, 0x20

    pop es
    pop ds
    popa

    iret


align 4, db 0
_KEY_BUFF: times RingBuff_size db 0
