; draw_color_bar( row, col );


draw_color_bar:
    enter 32, 0
    rsave edi, esi, eax, ebx, ecx, edx

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    
    mov ecx, 0
    .10L:
        cmp ecx, 16
        jae .10E

        mov eax, ecx
        and eax, 0x01
        shl eax, 3
        add eax, esi

        mov ebx, ecx
        shr ebx, 1
        add ebx, edi

        mov edx, ecx
        shl edx, 1
        mov edx, [.colors + edx]

        cdecl draw_str, eax, ebx, edx, .spaces

        inc ecx
        jmp .10L
    .10E:

    rload edi, esi, eax, ebx, ecx, edx
    leave
    ret


.spaces: db "        ", 0

.colors:
    dw 0x0000, 0x0800
    dw 0x0100, 0x0900
    dw 0x0200, 0x0a00
    dw 0x0300, 0x0b00
    dw 0x0400, 0x0c00
    dw 0x0500, 0x0d00
    dw 0x0600, 0x0e00
    dw 0x0700, 0x0f00
