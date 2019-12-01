; drive_get_param( struct drive *drive ) -> ax;
;   return:
;       ax: failed: 0, success: other
;   args:
;      *drive: struct drive. must set no


drive_get_param:
    enter 16, 0
    rsave bx, cx, es, si, di

    mov si, [bp + 4]
    
    xor ax, ax
    mov es, ax
    mov di, ax
    
    mov ah, 8
    mov dl, [si + Drive.no]
    int 0x13
    jc .10F
        mov al, cl
        and ax, 0b00111111
        
        shr cl, 6
        ror cx, 8
        inc cx

        movzx bx, dh
        inc bx

        mov [si + Drive.cyln], cx
        mov [si + Drive.head], bx
        mov [si + Drive.sect], ax

        jmp .10E
    .10F:
        mov ax, 0
    .10E:
    
    rload bx, cx, es, cx, bx
    leave
    ret
