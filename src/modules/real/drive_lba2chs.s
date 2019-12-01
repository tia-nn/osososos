; drive_lba2chs( struct drive *drive, struct drive *drv_chs, word lba )
;   return:
;       None
;   args:
;       drive:      drive info
;       drv_chs:    buffer
;       lbs:        lba


drive_lba2chs:
    enter 16, 0
    rsave bx, si, di

    mov si, [bp + 4]  ; drive
    mov di, [bp + 6]  ; drive_chs

    mov ax, [si + Drive.head]
    mul word [si + Drive.sect]
    mov bx, ax  ; シリンダあたりのセクタ数

    mov dx, 0
    mov ax, [bp + 8]  ; lba
    div bx
    mov [di + Drive.cyln], ax

    mov ax, dx
    mov dx, 0
    div word [si + Drive.sect]
    inc dx

    mov [di + Drive.head], ax
    mov [di + Drive.sect], dx

    rload bx, si, di
    leave
    ret

