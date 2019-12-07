; get_font_addr( struct Addr *buf )
;   buf: buffer of font_addr


get_font_addr:
    enter 16, 0
    rsave ax, bx, dx, si, bp

    mov si, [bp + 4]
    push es

    mov ax, 0x1133
    mov bh, 0x06
    int 0x10

    push es
    pop dx
    pop es

    mov [si + Addr.seg], dx
    mov [si + Addr.addr], bp
    
    rload ax, bx, dx, si, bp
    leave
    ret


.a: db "----:"
.b: db "----", 10, 13, 0
