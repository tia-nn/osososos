; void get_mem_info(  );
;   need global data 'ACPI_DATA', .addr, .len

get_mem_info:
    rsave eax, ebx, ecx, edx, si, di, bp

    cdecl puts, .s1

    mov bp, 0
    mov ebx, 0
    .10L:
        mov eax, 0x0000E820
        mov ecx, E820_RECORD_SIZE
        mov edx, 'PAMS'
        mov di, .b0
        int 0x15

        cmp eax, 'PAMS'
        je .12E
            jmp .10E
        .12E:

        jnc .14E
            jmp .10E
        .14E:

        cdecl put_mem_info, di

        mov eax, [di + 16]
        cmp eax, 3
        jne .15E
            mov eax, [di + 0]
            mov [ACPI_DATA.addr], eax

            mov eax, [di + 8]
            mov [ACPI_DATA.len], eax
        .15E:

        test ebx, ebx
        jz .16E
            inc bp
            and bp, 0x07
            jnz .16E
                cdecl puts, .s2
                
                mov ah, 0x10
                int 0x16

                cdecl puts, .s3
        .16E:

        test ebx, ebx
        jnz .10L
    .10E:

    cdecl puts, .s4

    rload eax, ebx, ecx, edx, si, di, bp
    ret

.b0: db '--------------------'
.s1: db ' Base_____________ Length___________ Type_________________', 10, 13, 0
.s2: db '<more...>', 0
.s3: db 13, '         ', 13, 0
.s4: db ' ---------------------------------------------------------', 10, 13, 0


put_mem_info:
    enter 16, 0
    rsave bx, si

    mov si, [bp + 4]
 
    cdecl itoa, word [si + 6], .p2 + 0, 4, 16, 0b0100
    cdecl itoa, word [si + 4], .p2 + 4, 4, 16, 0b0100
    cdecl itoa, word [si + 2], .p3 + 0, 4, 16, 0b0100
    cdecl itoa, word [si + 0], .p3 + 4, 4, 16, 0b0100

    cdecl itoa, word [si + 14], .p4 + 0, 4, 16, 0b0100
    cdecl itoa, word [si + 12], .p4 + 4, 4, 16, 0b0100
    cdecl itoa, word [si + 10], .p5 + 0, 4, 16, 0b0100
    cdecl itoa, word [si + 8], .p5 + 4, 4, 16, 0b0100

    cdecl itoa, word [si + 18], .p6 + 0, 4, 16, 0b0100
    cdecl itoa, word [si + 16], .p6 + 4, 4, 16, 0b0100

    cdecl puts, .s1

    mov bx, [si + 16]
    and bx, 0x07
    shl bx, 1
    add bx, .t0
    cdecl puts, word [bx]

    rload bx, si
    leave
    ret

.s1:
    db ' '
    .p2: db '--------_'
    .p3: db '-------- '
    .p4: db '--------_'
    .p5: db '-------- '
    .p6: db '--------', ' ', 0

.s2: db '(Unknown)', 10, 13, 0
.s3: db '(usable)', 10, 13, 0
.s4: db '(reserved)', 10, 13, 0
.s5: db '(ACPI data)', 10, 13, 0
.s6: db '(ACPI NVS)', 10, 13, 0
.s7: db '(bad memory)', 10, 13, 0

.t0: dw .s2, .s3, .s4, .s5, .s6, .s7

align 16, db 0
