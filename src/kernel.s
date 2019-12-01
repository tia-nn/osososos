%include "src/includes/constant.d.s"
%include "src/includes/macro.m.s"
%include "src/includes/struct.d.s"

org KERNEL_LOAD

BITS 32

kernel:
    hlt
    jmp kernel


times KERNEL_SIZE - ($ - $$) db 0
