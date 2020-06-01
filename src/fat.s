FAT1_START equ 0x0000_4000
FAT2_START equ 0x0002_4000
ROOT_START equ 0x0004_4000
FILE_START equ 0x0004_8000

ATTR_ACHIVE     equ 0b00100000
ATTR_VOLUME_ID  equ 0b00000100

times (FAT1_START) - ($ - $$) db 0

FAT1:
    db 0xff, 0xff
    dw 0xffff
    dw 0xffff

times (FAT2_START) - ($ - $$) db 0

FAT2:
    db 0xff, 0xff
    dw 0xffff
    dw 0xffff

times (ROOT_START) - ($ - $$) db 0

FAT_ROOT:
    db 'BOOTABLE', 'DSK'
    db ATTR_ACHIVE | ATTR_VOLUME_ID
    db 0x00
    db 0x00
    dw (0 << 11) | (0 << 5) | (0 / 2)
    dw (0 << 9) | (0 << 5) | (1)
    dw (0 << 9) | (0 << 5) | (1)
    dw 0x0000
    dw (0 << 11) | (0 << 5) | (0 / 2)
    dw (0 << 9) | (0 << 5) | (1)
    dw 0
    dd 0

    db 'hogehoge', 'txt'
    db ATTR_ACHIVE
    db 0x00
    db 0x00
    dw (0 << 11) | (0 << 5) | (0 / 2)
    dw (0 << 9) | (1 << 5) | (1)
    dw (0 << 9) | (1 << 5) | (1)
    dw 0x0000
    dw (0 << 11) | (0 << 5) | (0 / 2)
    dw (0 << 9) | (1 << 5) | (1)
    dw 2
    dd FILE.end - FILE


times FILE_START - ($ - $$) db 0

FILE: db 'hello, fat!'
.end: db 0

align 512, db 0

times (512 * 63) db 0

