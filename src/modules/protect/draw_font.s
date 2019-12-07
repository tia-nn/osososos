; draw_font( row, col );


draw_font:
    enter 32, 0
    rsave eax, ebx, ecx, esi, edi

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

    mov ecx, 0
    .10L:
        cmp ecx, 256
        jae .10E

        mov eax, ecx
        and eax, 0x0f
        add eax, esi

        mov ebx, ecx
        shr ebx, 4
        add ebx, edi

        cdecl draw_char, eax, ebx, 0x07, ecx

        inc ecx
        jmp .10L
    .10E:

    rload eax, ebx, ecx, esi, edi
    leave
    ret
