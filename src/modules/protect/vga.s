; vga_set_read_plane( plane )
;   return:
;       None
;   args:
;       plane: read plane

; vga_set_write_plane( plane )
;   return:
;       None
;   args:
;       plane: write plane

; vram_font_copy( font, vram, plane, color )
;   return:
;       None
;   args:
;       font: font addr
;       vram: vram addr
;       plane: write plane (single)
;       color: write color

; vram_bit_copy( bit, vram, plane, color )
;   return:
;       None
;   args:
;       bit:    bit
;       vram:   vram addr
;       plane:  write plane
;       color: write color

vga_set_read_plane:
    enter 32, 0
    rsave eax, edx

    mov ah, [ebp + 8]
    and ah, 0b0_0011
    mov al, 0x04  ; read map select register
    mov dx, 0x03ce  ; graphic port
    out dx, ax

    rload eax, edx
    leave
    ret


vga_set_write_plane:
    enter 32, 0
    rsave eax, edx

    mov ah, [ebp + 8]
    and ah, 0b0_1111
    mov al, 0x02
    mov dx, 0x3c4
    out dx, ax

    rload eax, edx
    leave
    ret


vram_font_copy:
    enter 32, 0
    rsave eax, ecx, ebx, edx, esi, edi

    mov esi, [ebp + 8]  ; font
    mov edi, [ebp + 12]  ; vram
    movzx eax, byte [ebp + 16]  ; plane
    movzx ebx, word [ebp + 20]  ; color

    test bh, al
    setz dh
    dec dh

    test bl, al
    setz dl
    dec dl

    cld
    mov ecx, 16
    .10L:
        lodsb
        mov ah, al
        not ah

        and al, dl
        
        test ebx, 0x0010
        jz .11F
            and ah, [edi]
            jmp .11E
        .11F:
            and ah, dh
        .11E:

        or al, ah

        mov [edi], al

        add edi, 80
        loop .10L
    .10E:

    rload eax, ecx, ebx, edx, esi, edi
    leave
    ret


vram_bit_copy:
    enter 32, 0
    rsave eax, ebx, edi

    mov edi, [ebp + 12]
    movzx eax, byte [ebp + 16]
    movzx ebx, word [ebp + 20]

    test bl, al
    setz bl
    dec bl

    mov al, [ebp + 8]
    mov ah, al
    not ah

    and ah, [edi]
    and al, bl
    or al, ah
    mov [edi], al

    rload eax, ebx, edi
    leave
    ret
