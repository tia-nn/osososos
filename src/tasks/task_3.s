task_3:
    enter 32, 0
    sub esp, 20
    push 0
    push 0

    mov esi, DRAW_PARAM

    mov eax, [esi + Rose.x0]
    mov ebx, [esi + Rose.y0]

    shr eax, 3
    shr ebx, 4
    dec ebx
    mov ecx, [esi + Rose.color_s]
    lea edx, [esi + Rose.title]

    cdecl draw_str, eax, ebx, ecx, edx

    mov eax, [esi + Rose.x0]
    mov ebx, [esi + Rose.x1]
    sub ebx, eax
    shr ebx, 1
    add ebx, eax
    mov [ebp - 4], ebx

    mov eax, [esi + Rose.y0]
    mov ebx, [esi + Rose.y1]
    sub ebx, eax
    shr ebx, 1
    add ebx, eax
    mov [ebp - 8], ebx

    mov eax, [esi + Rose.x0]
    mov ebx, [ebp - 8]
    mov ecx, [esi + Rose.x1]

    cdecl draw_line, eax, ebx, ecx, ebx, dword [esi + Rose.color_x]

    mov eax, [esi + Rose.y0]
    mov ebx, [ebp - 4]
    mov ecx, [esi + Rose.y1]

    cdecl draw_line, ebx, eax, ebx, ecx, dword [esi + Rose.color_y]

    mov eax, [esi + Rose.x0]
    mov ebx, [esi + Rose.y0]
    mov ecx, [esi + Rose.x1]
    mov edx, [esi + Rose.y1]

    cdecl draw_rect, eax, ebx, ecx, edx, dword [esi + Rose.color_z]

    mov eax, [esi + Rose.x1]
    sub eax, [esi + Rose.x0]
    shr eax, 1
    mov ebx, eax
    shr ebx, 4
    sub eax, ebx

    cdecl fpu_rose_init, eax, dword [esi + Rose.n], dword [esi + Rose.d]

    mov dword [ebp - 12], 0
    mov dword [ebp - 16], 0
    mov dword [ebp - 20], 0
    .10L:

        lea ebx, [ebp - 12]
        lea ecx, [ebp - 16]
        mov eax, [ebp - 20]

        cdecl fpu_rose_update, ebx, ecx, eax

        mov edx, 0
        add eax, 10000
        ; mov ebx, 360 * 100
        ; div ebx
        
        ; mov eax, edx
        ; mov edx, 0
        ; mul 100

        ; mov [ebp - 20], edx

        mov [ebp - 20], eax

        mov ecx, [ebp - 12]
        mov edx, [ebp - 16]
        add ecx, [ebp - 4]
        add edx, [ebp - 8]
        mov ebx, [esi + Rose.color_f]

        cdecl itoa, ecx, .s4, 6, 10, 0
        cdecl itoa, edx, .s5, 6, 10, 0
        cdecl itoa, dword [ebp - 20], .s6, 6, 10, 0
        cdecl draw_str, dword 0, dword 0, dword 0x0700, dword .s4

        int 0x82  ; draw_dot

        cdecl wait_tick, 2

        mov ebx, [esi + Rose.color_b]
        int 0x82

        jmp .10L


.c1000: dd 1000
.c180: dd 180
.bcd: times 10 db 0
.s0: db "Task-3", 0
.s1: db "-"
.s2: db "0."
.s3: db "000", 0
.s4: db "------ , "
.s5: db "------ / "
.s6: db "------", 0

DRAW_PARAM:
    istruc Rose
        at Rose.x0, dd 16
        at Rose.y0, dd 32
        at Rose.x1, dd 416
        at Rose.y1, dd 432

        at Rose.n, dd 2
        at Rose.d, dd 1

        at Rose.color_x, dd 0x0007
        at Rose.color_y, dd 0x0007
        at Rose.color_z, dd 0x000f
        at Rose.color_s, dd 0x030f
        at Rose.color_f, dd 0x000f
        at Rose.color_b, dd 0x0003

        at Rose.title, db "Task-3", 0
    iend


fpu_rose_init:
    enter 32, 0
    push dword 180

    fldpi
    fidiv dword [ebp - 4]
    fild dword [ebp + 12]
    fidiv dword [ebp + 16]
    fild dword [ebp + 8]

    leave
    ret


; (*px, *py, t)
fpu_rose_update:
; | A | k | r

    enter 32, 0
    rsave eax, ebx

    mov eax, [ebp + 8]  ; px
    mov ebx, [ebp + 12]  ; py

    fild dword [ebp + 16]  ; t
    fmul st0, st3  ; t * r
    fld st0

; | sheta=t*r | sheta | A | k | r

    fsincos  ; push sin, cos

    fxch st2  ; cos <-> sheta
    fmul st0, st4  ; sheta * k
    fsin
    fmul st0, st3  ; A sin (sheta * k)

    fxch st2  ; Asin... <-> sheta
    fmul st0, st2
    fistp dword [eax]
    
    fmulp st1, st0
    fchs
    fistp dword [ebx]

    rload eax, ebx
    leave
    ret
