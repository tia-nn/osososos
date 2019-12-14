; draw_char( row, col, color, ch )
;   return:
;       None
;   args:
;       row: 0 ~ 79
;       col: 0 ~ 29
;       color: write color
;       ch: write char


draw_char:
    enter 32, 0
    rsave ebx, esi, edi

    movzx esi, byte [ebp + 20]  ; char
    shl esi, 4
    add esi, [FONT_ADDR]

    ; addr = 0xa_0000 + (640 / 8 * 16) * y + x
    mov edi, [ebp + 12]
    shl edi, 8
    lea edi, [edi * 4 + edi + 0xa0000]
    add edi, [ebp + 8]

    movzx ebx, word [ebp + 16]

    %ifdef USE_TEST_AND_SET
        cdecl test_and_set, IN_USE
    %endif

    cdecl vga_set_read_plane, 0x03
    cdecl vga_set_write_plane, 0x08
    cdecl vram_font_copy, esi, edi, 0x08, ebx

    cdecl vga_set_read_plane, 0x02
    cdecl vga_set_write_plane, 0x04
    cdecl vram_font_copy, esi, edi, 0x04, ebx

    cdecl vga_set_read_plane, 0x01
    cdecl vga_set_write_plane, 0x02
    cdecl vram_font_copy, esi, edi, 0x02, ebx

    cdecl vga_set_read_plane, 0x00
    cdecl vga_set_write_plane, 0x01
    cdecl vram_font_copy, esi, edi, 0x01, ebx

    %ifdef USE_TEST_AND_SET
        mov dword [IN_USE], 0
    %endif

    rload ebx, esi, edi
    leave
    ret

align 4, db 0
IN_USE: dd 0
