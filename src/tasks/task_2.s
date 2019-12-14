task_2:
    cdecl draw_str, 63, 1, 0x07, .s0

    fild dword [.c1000]
    fldpi
    fidiv dword [.c180]
    fldpi
    fadd st0, st0
    fldz
    ; now = 0 | max = pi * 2 | delta = pi / 180 = 1 dec | 1000 | xxxxxx

    .10L:
        fadd st0, st2
        fprem
        fld st0
        fsin
        fmul st0, st4
        fbstp [.bcd]

        mov eax, [.bcd]
        mov ebx, eax

        and eax, 0x0f0f
        or eax, 0x3030
        
        shr ebx, 4
        and ebx, 0x0f0f
        or ebx, 0x3030

        mov [.s2 + 0], bh
        mov [.s3 + 0], ah
        mov [.s3 + 1], bl
        mov [.s3 + 2], al

        mov eax, 7
        bt [.bcd + 9], eax
        jc .12F
            mov byte [.s1], "+"
            jmp .12E
        .12F:
            mov byte [.s1], "-"
        .12E:
        
        cdecl draw_str, 72, 1, 0x07, .s1

        cdecl wait_tick, 10
        jmp .10L

.c1000: dd 1000
.c180: dd 180
.bcd: times 10 db 0
.s0: db "Task-2", 0
.s1: db "-"
.s2: db "0."
.s3: db "000", 0
