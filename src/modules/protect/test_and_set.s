; test_and_set( *addr )

test_and_set:
    enter 32, 0
    rsave eax, ebx

    mov eax, 0
    mov ebx, [ebp + 8]

    .10L:
        lock bts [ebx], eax
        jnc .10E

        .12L:
            bt [ebx], eax
            jc .12L
            jmp .10L
    .10E:

    rload eax, ebx
    leave
    ret
