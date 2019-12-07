; ringbuff_rd( *ring, *buff );
;   return:
;       success(1), defeat(0)
;   args:
;       ring: RingBuff
;       buff: data buffer

; ringbuff_rd( *ring, data );
;   return:
;       success(1), defeat(0)
;   args:
;       ring: RingBuff
;       data: write data


ringbuff_rd:
    enter 32, 0
    rsave ebx, esi, edi

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

    mov eax, 0
    mov ebx, [esi + RingBuff.rp]
    cmp ebx, [esi + RingBuff.wp]
    je .10E
        mov al, [esi + RingBuff.item + ebx]
        mov [edi], al
        inc ebx
        and ebx, RING_INDEX_MASK
        mov [esi + RingBuff.rp], ebx
        mov eax, 1
    .10E:

    rload ebx, esi, edi
    leave
    ret


ringbuff_wr:
    enter 32, 0
    rsave ecx, ebx, esi, edi

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]

    mov eax, 0
    mov ebx, [esi + RingBuff.wp]
    mov ecx, ebx
    inc ecx
    and ecx, RING_INDEX_MASK

    cmp ecx, [esi + RingBuff.rp]
    je .10E
        mov al, [ebp + 12]

        mov [esi + RingBuff.item + ebx], al
        mov [esi + RingBuff.wp], ecx
        mov eax, 1
    .10E:

    rload ecx, ebx, esi, edi
    leave
    ret
    

draw_key:
    enter 32, 0
    rload eax, ecx, edx, ebx, esi, edi

    mov esi, [ebp + 8]
    mov edx, [ebp + 12]
    mov edi, [ebp + 16]

    mov ebx, [esi + RingBuff.wp]
    lea esi, [esi + RingBuff.item]
    mov ecx, RING_ITEM_SIZE

    .10L:
        dec ebx
        and ebx, RING_INDEX_MASK
        mov al, [esi + ebx]
        
        cdecl itoa, eax, .tmp, 2, 16, 0x0100
        cdecl draw_str, edx, edi, 0x0002, .tmp

        add edx, 3

        loop .10L
    .10E:

    rload eax, ecx, edx, ebx, esi, edi
    leave
    ret


.tmp: db "--", 0
