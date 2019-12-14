wait_tick:
    enter 32, 0
    rsave eax, ecx

    mov ecx, [ebp + 8]
    mov eax, [TIMER_COUNT]

    .10L:
        cmp eax, [TIMER_COUNT]
        je .10L
        inc eax
        int 0x83
        loop .10L
    
    rload eax, ecx
    leave
    ret
