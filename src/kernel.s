%include "src/includes/constant.d.s"
%include "src/includes/macro.m.s"
%include "src/includes/struct.d.s"

org KERNEL_LOAD

BITS 32

kernel:

    cdecl draw_font, 63, 13
    cdecl draw_str, 25, 14, 0x10f, .s0
    cdecl draw_color_bar, 63, 4

    call init_int
    call init_pic

    set_vect 0x00, int_zero_div
    set_vect 0x20, int_timer
    set_vect 0x21, int_keyboard
    set_vect 0x28, int_rtc

    cdecl rtc_int_en, 0x10
    call int_en_timer0

    outp 0x21, 0b_1111_1000  ; slave pic, kbc, timer
    outp 0xa1, 0b_1111_1110  ; rtc

    sti

    cdecl ringbuff_wr, _KEY_BUFF, 0xff

    .END:
        cdecl ringbuff_rd, _KEY_BUFF, .int_key
        test eax, eax
        jz .10E
            cdecl draw_key, _KEY_BUFF, 2, 29
        .10E:

        cdecl draw_time, 72, 0, 0x0700, dword [RTC_TIME]
        call draw_rotation_bar
        hlt
        jmp .END


.s0: db "Hello, kernel.", 0
.test: db "hoge", 0
.time: dd 0
.int_key: dd 0


align 4, db 0
FONT_ADDR: dd FONT_8_16


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

times KERNEL_SIZE - ($ - $$) db 0
