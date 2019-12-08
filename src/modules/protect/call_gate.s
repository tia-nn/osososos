call_gate:
    enter 32, 0
    pusha
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    mov eax, dword [ebp + 12]
    mov ebx, dword [ebp + 16]
    mov ebx, dword [ebp + 20]
    mov edx, dword [ebp + 24]
    cdecl draw_str, eax, ebx, ecx, edx

    pop es
    pop ds
    popa
    leave
    retf 4 * 4
