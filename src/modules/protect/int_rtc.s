int_rtc:
    pusha
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    cdecl rtc_get_time, RTC_TIME

    outp 0x70, 0x0c
    in al, 0x71

    mov al, 0x20
    out 0xa0, al
    out 0x20, al

    pop es
    pop ds
    popa

    iret

RTC_TIME: dd 0xffffffff


rtc_int_en:
    enter 32, 0
    push eax

    outp 0x70, 0x0b
    in al, 0x71
    or al, [ebp + 8]
    out 0x71, al

    pop eax
    leave
    ret
