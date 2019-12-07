VECT_BASE equ 0x0010_0000  ; 0010_0000:0010_07ff

align 4
IDTR:   dw 8 * 256 - 1
        dd VECT_BASE


int_stop:
    sti
    
    cdecl draw_str, 25, 15, 0x060f, eax

    mov eax, [esp + 0]
    cdecl itoa, eax, .p1, 8, 16, 0b0100

    mov eax, [esp + 4]
    cdecl itoa, eax, .p2, 8, 16, 0b0100

    mov eax, [esp + 8]
    cdecl itoa, eax, .p3, 8, 16, 0b0100

    mov eax, [esp + 12]
    cdecl itoa, eax, .p4, 8, 16, 0b0100

    cdecl draw_str, 25, 16, 0xf04, .s1
    cdecl draw_str, 25, 17, 0xf04, .s2
    cdecl draw_str, 25, 18, 0xf04, .s3
    cdecl draw_str, 25, 19, 0xf04, .s4

    .END:
        hlt
        jmp .END


.s1: db "ESP+ 0 :"
    .p1: db "--------", 0
.s2: db "   + 4 :"
    .p2: db "--------", 0
.s3: db "   + 8 :"
    .p3: db "--------", 0
.s4: db "   + 12:"
    .p4: db "--------", 0


int_default:
    pushf
    push cs
    push int_stop

    mov eax, .s0
    iret


.s0: db "<    STOP    >", 0


init_int:
    rsave eax, ebx, ecx, edi

    lea eax, [int_default]
    mov ebx, 0x0008_8e00
    xchg ax, bx

    mov ecx, 256
    mov edi, VECT_BASE

    .10L:
        mov [edi + 0], ebx
        mov [edi + 4], eax
        add edi, 8
        loop .10L

    lidt [IDTR]

    rload eax, ebx, ecx, edi

    ret


int_zero_div:
    pushf
    push cs
    push int_stop

    mov eax, .s0
    iret

.s0: db "<  ZERO DIV  >", 0
