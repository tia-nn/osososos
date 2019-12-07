; draw_time( row, col, color, time )


draw_time:
    enter 32, 0
    rsave eax, ebx

    mov eax, [ebp + 20]  ; time
    movzx ebx, al  ; sec

    cdecl itoa, ebx, .sec, 2, 16, 0b0100

    movzx ebx, ah
    cdecl itoa, ebx, .min, 2, 16, 0b0100

    shr eax, 16
    cdecl itoa, eax, .hour, 2, 16, 0b0100

    cdecl draw_str, dword [ebp + 8], dword [ebp + 12], dword [ebp + 16], .hour

    rload eax, ebx
    leave
    ret

.hour: db "  :"
.min: db "  :"
.sec: db "  ", 0
