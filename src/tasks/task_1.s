task_1:
    cdecl draw_str, 63, 0, 0x07, .s0

    .10L:
        cdecl draw_time, 72, 0, 0x0700, dword [RTC_TIME]

        int 0x83
        jmp .10L

.s0: db "Task-1", 0
