; memcpy( *dist, *src, size )

memcpy:
    enter 32, 0
    rsave eax, ecx, edi, esi

    mov edi, [ebp + 8]
    mov esi, [ebp + 12]
    mov ecx, [ebp + 16]

    .10L:
        mov al, byte [esi]
        stosb
        inc esi
        loop .10L

    rload eax, ecx, edi, esi
    leave
    ret
