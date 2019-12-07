%macro cdecl 1-* .nolist
    %rep %0 - 1
        push %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1
        call %1
    %if 1 < %0
        add sp, (__BITS__ >> 3) * (%0 - 1)
    %endif
%endmacro

%macro rsave 1-* .nolist
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro rload 1-* .nolist
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

%macro set_vect 1-* .nolist
    push eax
    push edi

    mov edi, VECT_BASE + (%1 * 8)
    mov eax, %2

    mov [edi + 0], ax
    shr eax, 16
    mov [edi + 6], ax

    pop edi
    pop eax
%endmacro

%macro outp 2
    mov al, %2
    out %1, al
%endmacro
