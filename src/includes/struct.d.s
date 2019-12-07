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
