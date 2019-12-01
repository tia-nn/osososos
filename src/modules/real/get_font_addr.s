; get_font_addr( struct Addr *buf )
;   buf: buffer of font_addr


get_font_addr:
    enter 16, 0
    rsave ax, bx, si, es, bp

    mov si, [bp + 4]

    mov ax, 0x1133
    mov bh, 0x06
    int 0x10

    mov [si + Addr.seg], es
    mov [si + Addr.addr], bp
    
    rload ax, bx, si, es, bp
    leave
    ret
