; dvire_read_chs( struct drive *drive, word sect, void *dst ) -> ax;
;   return:
;       ax: quantity of loaded sector
;   args:
;       drive:  pointer of struct drive which loaded drive
;       sect:   quantity of sector to be load
;       dst:    load planned location

drive_read_chs:
    enter 16, 0

    push 3  ; bp - 2: number of trials
    push 0  ; (align)

    rsave bx, cx, dx, es, si
    
    mov si, [bp + 4]  ; drive

    mov ch, [si + Drive.cyln]
    mov cl, [si + Drive.cyln + 1]
    shl cl, 6
    or cl, [si + Drive.sect]

    mov dh, [si + Drive.head]
    mov dl, [si + Drive.no]
    mov ax, 0x0000
    mov es, ax  ; load to es:bx
    mov bx, [bp + 8]  ; dst

    .10L:
        mov ah, 0x02  ; bios: disk: read sector
        mov al, [bp + 6]  ; sect
        int 0x13  ; bios: disk

        jnc .11E
            mov al, 0
            jmp .10E
        .11E:
        
        test al, al
        jnz .10E
            mov ax, 0
            dec word [bp - 2]  ; number of trial
            jnz .10L
    .10E:

    mov ah, 0

    rload bx, cx, dx, es, si
    leave
    ret
