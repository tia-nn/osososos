; itoa( dword val, char *buff, dword size, dword base, dword flags );
;   return:
;       None
;   args:
;       val:    change source value
;       buff:   write buffer
;       size:   buffer size (byte)
;       base:   radix
;       flags:
;           0b0001: is_signed
;           0b0010: add_sign
;           0b0100: fill '0'


itoa:
    enter 32, 0
    rsave eax, ebx, ecx, edx, esi, edi

    mov eax, [ebp+8]  ; val
    mov esi, [ebp+12]  ; dst
    mov ecx, [ebp+16]  ; size

    mov edi, esi
    add edi, ecx
    dec edi  ; dst + size - 1; buffer end addr

    mov ebx, [ebp + 24]  ; flags

    ; is signed

    test ebx, 0b0001
    jz .10E
        cmp eax, 0
        jnl .10E
            or ebx, 0b0010
    .10E:

    ; output sign

    test ebx, 0b0010
    jz .20E
        cmp eax, 0
        jnl .21F
            neg eax
            mov byte [esi], '-'
            jmp .21E
        .21F:
            mov byte [esi], '+'
        .21E:
        dec ecx
    .20E:

    ; decode value

    mov ebx, [ebp+20]  ; base
    .30S:
        mov edx, 0
        div ebx
        
        mov esi, edx
        mov dl, [.ascii + esi]
        mov [edi], dl
        dec edi
        
        test eax, eax
        loopnz .30S
    
    ; 0 or ' ' fill

    test ecx, ecx
    jz .40E
        mov al, ' '
        test dword [ebp+24], 0b0100  ; flags: 0 fill
        jz .41E
            mov al, '0'
        .41E:
        std
        rep stosb
    .40E:

    rload eax, ebx, ecx, edx, esi, edi
    leave
    ret

.ascii: db '0123456789abcdef'
