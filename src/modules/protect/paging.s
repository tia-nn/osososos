; page_set_4m( *addr )

page_set_4m:
    enter 32, 0
    pushad

    mov edi, [ebp + 8]
    
    mov eax, 0x00000_000
    mov ecx, 1024
    rep stosd

    mov eax, edi
    and eax, ~0x00000_fff
    or eax, 7
    mov [edi - (1024 * 4)], eax

    mov eax, 0x00000_007
    mov ecx, 1024
    .10L:
        stosd
        add eax, 0x00001_000
        loop .10L
    
    popad
    leave
    ret


init_page:
    pushad

    cdecl page_set_4m, CR3_BASE
    mov [CR3_BASE + 0x1000 + 0x108 * 4], dword 0

    popad
    ret
