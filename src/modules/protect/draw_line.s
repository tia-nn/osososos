; draw_line( x0, y0, x1, y1, color );


%define v_sum   4
%define v_x0    8
%define v_dx    12
%define v_inc_x 16
%define v_y0    20
%define v_dy    24
%define v_inc_y 28

draw_line:
    enter 32, 0
    sub esp, 28
    rsave eax, ebx, ecx, edx, edi, esi

    mov dword [ebp - v_sum], 0

    mov eax, [ebp + 8]  ; x0
    mov ebx, [ebp + 16]  ; x1
    sub ebx, eax  ; 幅
    jge .10F
        neg ebx
        mov esi, -1
        jmp .10E
    .10F:
        mov esi, 1
    .10E:

    mov ecx, [ebp + 12]  ; y0
    mov edx, [ebp + 20]  ; y1
    sub edx, ecx  ; 高さ
    jge .20F
        neg edx
        mov edi, -1
        jmp .20E
    .20F:
        mov edi, 1
    .20E:

    mov [ebp - v_x0], eax
    mov [ebp - v_dx], ebx
    mov [ebp - v_inc_x], esi

    mov [ebp - v_y0], ecx
    mov [ebp - v_dy], edx
    mov [ebp - v_inc_y], edi

    cmp ebx, edx
    jg .30F
        lea esi, [ebp - v_y0]
        lea edi, [ebp - v_x0]
        jmp .30E
    .30F:
        lea esi, [ebp - v_x0]
        lea edi, [ebp - v_y0]
    .30E:

    mov ecx, [esi - 4]
    test ecx, ecx
    jnz .40E
        mov ecx, 1
    .40E:
    
    .50L:
        cdecl draw_pixel, dword [ebp - v_x0], dword [ebp - v_y0], dword [ebp + 24]

        mov eax, [esi - 8]
        add [esi - 0], eax

        mov eax, [ebp - v_sum]
        add eax, [edi - 4]

        mov ebx, [esi - 4]

        cmp eax, ebx
        jl .51E
            sub eax, ebx
            mov ebx, [edi - 8]
            add [edi - 0], ebx
        .51E:

        mov [ebp - v_sum], eax

        loop .50L
    .50E:

    cdecl draw_str, 100, 100, 0x0f, .s

    rload eax, ebx, ecx, edx, edi, esi
    leave
    ret

.s: db "draw_line end", 0


%undef v_sum
%undef v_x0
%undef v_dx
%undef v_inc_x
%undef v_y0
%undef v_dy
%undef v_inc_y

