; itoa( word val, char *buff, word size, word base, word flags );
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
    enter 16, 0
    rsave ax, bx, cx, dx, si, di

    mov ax, [bp+4]  ; val
    mov si, [bp+6]  ; dst
    mov cx, [bp+8]  ; size

    mov di, si
    add di, cx
    dec di  ; dst + size - 1; buffer end addr

    mov bx, word [bp + 12]  ; flags

    ; is signed

    test bx, 0b0001
    jz .10E
        cmp ax, 0
        jnl .10E
            or bx, 0b0010
    .10E:

    ; output sign

    test bx, 0b0010
    jz .20E
        cmp ax, 0
        jnl .21F
            neg ax
            mov byte [si], '-'
            jmp .21E
        .21F:
            mov byte [si], '+'
        .21E:
        dec cx
    .20E:

    ; decode value

    mov bx, [bp+10]  ; base
    .30S:
        mov dx, 0
        div bx
        
        mov si, dx
        mov dl, [.ascii + si]
        mov [di], dl
        dec di
        
        test ax, ax
        loopnz .30S
    
    ; 0 or ' ' fill

    test cx, cx
    jz .40E
        mov al, ' '
        test word [bp+12], 0b0100  ; flags: 0 fill
        jz .41E
            mov al, '0'
        .41E:
        std
        rep stosb
    .40E:

    rload ax, bx, cx, dx, si, di
    leave
    ret

.ascii: db '0123456789abcdef'
