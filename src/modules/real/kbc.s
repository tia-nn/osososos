; Kbc_Data_Write( data ) -> ax;
;   return:
;       ax: defeat(0), seccess(other)
;   args:
;       data: write data.



KBC_data_write:
    enter 16, 0
    push cx

    mov cx, 3 + 1
    .10L:
        in al, 0x64
        test al, 0b00000010  ; 入力バッファ full
        loopnz .10L

    test cx, cx
    jz .20E
        mov ax, [bp + 4]
        out 0x60, al
    .20E:

    mov ax, cx
    pop cx
    leave
    ret


KBC_data_read:
    enter 16, 0
    push cx

    mov cx, 3 + 1
    .10L:
        in al, 0x64
        test al, 0b00000001
        loopz .10L

    test cx, cx
    jz .20E
        xor ax, ax
        in al, 0x60

        mov di, [bp + 4]
        mov [di + 0], ax
    .20E:

    mov ax, cx

    pop cx
    leave
    ret
.s1: db '--------', 10, 13, 0


KBC_cmd_write:
    enter 16, 0
    push cx

    mov cx, 3 + 1
    .10L:
        in al, 0x64
        test al, 0x02
        loopnz .10L

    test cx, cx
    jz .20E
        mov ax, [bp + 4]
        out 0x64, al
    .20E:

    mov ax, cx
    pop cx
    leave
    ret
