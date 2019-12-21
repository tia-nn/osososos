int_timer:
    pushad
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    inc dword [TIMER_COUNT]

    outp 0x20, 0x20

    str ax
    cmp ax, SS_TASK_1
    je .11F
    cmp ax, SS_TASK_2
    je .12F
    cmp ax, SS_TASK_3
    je .13F
    cmp ax, SS_TASK_4
    je .14F
    cmp ax, SS_TASK_5
    je .15F
    cmp ax, SS_TASK_6
    je .16F
        jmp SS_TASK_1:0
        jmp .10E
    .11F:
        jmp SS_TASK_2:0
        jmp .10E
    .12F:
        jmp SS_TASK_3:0
        jmp .10E
    .13F:
        jmp SS_TASK_4:0
        jmp .10E
    .14F:
        jmp SS_TASK_5:0
        jmp .10E
    .15F:
        jmp SS_TASK_6:0
        jmp .10E
    .16F:
        jmp SS_TASK_0:0
        jmp .10E
    .10E:

    pop es
    pop ds
    popad

    iret


align 4, db 0
TIMER_COUNT: dq 0
