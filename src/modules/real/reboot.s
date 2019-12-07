; reboot()
;   wait for user input and reboot

reboot:
    cdecl puts, .s0

    .10S:
        mov ah, 0x10
        int 0x16

        cmp al, ' '
        jne .10S
    
    cdecl puts, .s1

    int 0x19

.s0: db 10, 13, 'Push SPACE key to reboot.', 0
.s1: db 10, 14, 10, 13, 0
