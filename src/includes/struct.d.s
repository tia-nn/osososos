; real

struc Drive
    .no     resw 1
    .cyln   resw 1
    .head   resw 1
    .sect   resw 1
endstruc

struc Addr
    .seg    resw 1
    .addr   resw 1
endstruc


; protect

struc RingBuff
    .rp     resd 1
    .wp     resd 1
    .item   resb RING_ITEM_SIZE
endstruc


struc Rose
    .x0     resd 1
    .y0     resd 1
    .x1     resd 1
    .y1     resd 1

    .n      resd 1
    .d      resd 1
    
    .color_x    resd 1
    .color_y    resd 1
    .color_z    resd 1
    .color_s    resd 1
    .color_f    resd 1
    .color_b    resd 1

    .title      resb 16
endstruc
