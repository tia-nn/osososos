%define USE_SYSTEM_CALL
%define USE_TEST_AND_SET

%include "src/includes/constant.d.s"
%include "src/includes/macro.m.s"
%include "src/includes/struct.d.s"

org KERNEL_LOAD

BITS 32

kernel:
    set_desc GDT.tss_0, TSS_0
    set_desc GDT.tss_1, TSS_1
    set_desc GDT.tss_2, TSS_2
    set_desc GDT.tss_3, TSS_3
    set_desc GDT.tss_4, TSS_4
    set_desc GDT.tss_5, TSS_5
    set_desc GDT.tss_6, TSS_6

    set_gate GDT.call_gate, call_gate

    set_desc GDT.ldt, LDT, LDT_LIMIT

    lgdt [GDTR]

    mov esp, SP_TASK_0

    mov ax, SS_TASK_0
    ltr ax


    call init_int
    call init_pic
    call init_page

    mov eax, CR3_BASE
    mov cr3, eax

    mov eax, cr0
    or eax, (1 << 31)
    mov cr0, eax
    jmp $ + 2

    set_vect 0x00, int_zero_div
    set_vect 0x07, int_nm
    set_vect 0x0e, int_pf
    set_vect 0x20, int_timer
    set_vect 0x21, int_keyboard
    set_vect 0x28, int_rtc
    set_vect 0x81, trap_gate_81, 0xef00
    set_vect 0x82, trap_gate_82, 0xef00
    set_vect 0x83, trap_gate_83, 0xef00

    cdecl rtc_int_en, 0x10
    call int_en_timer0

    outp 0x21, 0b_1111_1000  ; slave pic, kbc, timer
    outp 0xa1, 0b_1111_1110  ; rtc

    sti


    cdecl draw_font, 63, 13
    cdecl draw_str, 25, 14, 0x10f, .s0
    cdecl draw_color_bar, 63, 4

    .END:
        cdecl ringbuff_rd, _KEY_BUFF, .int_key
        test eax, eax
        jz .10E
            cdecl draw_key, _KEY_BUFF, 2, 29
        .10E:
        call draw_rotation_bar

        hlt
        jmp .END


.s0: db " Hello, kernel. ", 0
.test: db "hoge", 0
.time: dd 0
.int_key: dd 0


align 4, db 0
FONT_ADDR: dd FONT_8_16


%include "src/tasks/task_1.s"
%include "src/tasks/task_2.s"
%include "src/tasks/task_3.s"

%include "src/descriptor.s"

%include "src/includes/font/hankaku.s"
%include "src/modules/protect/vga.s"
%include "src/modules/protect/draw_char.s"
%include "src/modules/protect/draw_font.s"
%include "src/modules/protect/draw_str.s"
%include "src/modules/protect/draw_color_bar.s"
%include "src/modules/protect/draw_pixel.s"
%include "src/modules/protect/draw_line.s"
%include "src/modules/protect/draw_rect.s"
%include "src/modules/protect/rtc.s"
%include "src/modules/protect/itoa.s"
%include "src/modules/protect/draw_time.s"
%include "src/modules/protect/interrupt.s"
%include "src/modules/protect/pic.s"
%include "src/modules/protect/int_rtc.s"
%include "src/modules/protect/ring_buff.s"
%include "src/modules/protect/int_keyboard.s"
%include "src/modules/protect/int_timer.s"
%include "src/modules/protect/timer.s"
%include "src/modules/protect/draw_rotation_bar.s"
%include "src/modules/protect/call_gate.s"
%include "src/modules/protect/trap_gate.s"
%include "src/modules/protect/test_and_set.s"
%include "src/modules/protect/int_nm.s"
%include "src/modules/protect/wait_tick.s"
%include "src/modules/protect/paging.s"
%include "src/modules/protect/int_pf.s"
%include "src/modules/protect/memcpy.s"

times KERNEL_SIZE - ($ - $$) db 0
