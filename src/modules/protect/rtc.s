; rtc_get_time( dst ) -> eax:success(0), fail(1)


rtc_get_time:
    enter 32, 0
    push ebx

    mov al, 0x0a
    out 0x70, al
    in al, 0x71
    
    test al, 0x80
    jz .10F
        mov eax, 1
        jmp .10E
    .10F:

        mov al, 0x04
        out 0x70, al
        in al, 0x71

        shl eax, 8

        mov al, 0x02
        out 0x70, al
        in al, 0x71

        shl eax, 8

        mov al, 0x00
        out 0x70, al
        in al, 0x71

        and eax, 0x_00_ff_ff_ff

        mov ebx, [ebp + 8]
        mov [ebx], eax

        mov eax, 0
    .10E:

    pop ebx
    leave
    ret
