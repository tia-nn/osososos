; puts( *str );
;   return:
;       None
;   args:
;       str: string pointer. string must be NULL terminated.

puts:
    enter 16, 0
    rsave ax, bx, si

    mov si, [bp + 4]  ; *str
    mov ah, 0x0e  ; bios: video: putchar
    mov bx, 0x0  ;  bios: video: putchar: page_no, color

    cld
    .L:
        lodsb
        test al, al
        jz .E

        int 0x10  ; put char

        jmp .L
    .E:

    rload ax, bx, si
    leave
    ret
