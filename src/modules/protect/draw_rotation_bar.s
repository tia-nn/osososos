draw_rotation_bar:
    mov eax, [TIMER_COUNT]
    shr eax, 4

    cmp eax, [.index]
    je .10E
        mov [.index], eax
        and eax, 0x03
        mov al, [.table + eax]
        cdecl draw_char, 0, 29, 0x000f, eax
    .10E:

    ret

.index: dd 0
.table: db "|/-\"
