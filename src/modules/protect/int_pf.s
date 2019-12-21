int_pf:
    pushad
    push es
    push ds

    mov eax, cr2
    and eax, ~0x00000_fff
    cmp eax, 0x0010_8000
    jne .10F
        mov [CR3_BASE + 0x1000 + 0x108 * 4], dword 0x00108_007
        cdecl memcpy, 0x0010_8000, DRAW_PARAM, Rose_size
    jmp .10E
    .10F:
        add esp, 8
        popad

        pushf
        push cs
        push int_stop
        
        mov eax, cr2
        cdecl itoa, eax, .s1, 8, 16, 0b0100
        mov eax, .s0
        iret
    .10E:

    pop ds
    pop es
    popad
    add esp, 4
    iret

.s0: db " < PAGE_FAULT > cr2: 0x"
.s1: db "--------", 0
