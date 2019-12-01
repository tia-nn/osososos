; drive_read_lba( struct drive *drive, word lba, word sect, void *dst) -> ax;
;   return:
;       ax: quantity of loaded sector
;   args:
;       drive:  pointer of struct drive which loaded drive
;       lba:    entry point lba
;       sect:   quantity of sector to be load
;       dst:    load planned location


drive_read_lba:
    enter 16, 0
    rsave bx, si

    mov si, [bp + 4]  ; drive
    mov ax, [bp + 6]  ; lba

    ccall drive_lba2chs, si, .chs, ax

    mov ax, [si + Drive.no]
    mov [.chs + Drive.no], ax

    ccall drive_read_chs, .chs, word [bp + 8], word [bp + 10]

    rload bx, si
    leave
    ret

.chs: times Drive_size db 0
