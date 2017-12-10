global _main
extern _printf, _exit, _read

section .text
_main:
    push dword inputlen
    push dword input
    push dword 0
    call _read ;     read(int fd, void *buf, size_t nbytes);
    add esp, 12

    mov al, 0  ; garbage flag
    mov ecx, 0
start:
    cmp ecx, inputlen
    jge done

caseBang:
    cmp [ecx+input], byte '!'
    jne caseGarbage
    inc ecx
    jmp tail

caseGarbage:
    cmp al, 0
    jz caseLt

    cmp [ecx+input], byte '>'
    jne otherGarbage
    mov al, 0
    jmp tail
otherGarbage:
    add [garbagetotal], dword 1
    jmp tail

caseLt:
    cmp [ecx+input], byte '<'
    jne caseLc
    mov al, 1
    jmp tail

caseLc:
    cmp [ecx+input], byte '{'
    jne caseRc
    add [depth], dword 1
    jmp tail

caseRc:
    cmp [ecx+input], byte '}'
    jne tail
    mov edx, [depth] 
    add [total], edx
    dec edx
    mov [depth], edx
    jmp tail

tail:
    inc ecx
    jmp start

done:
    sub esp, 4
    push dword [total]
    push dword fmt
    call _printf

    add esp, 8
    push dword [garbagetotal]
    push dword fmt
    call _printf

exit:
    mov [esp], dword 0
    call _exit

section .data
  fmt db "%zu", 0xa, 0

  input resb 25000
  inputlen equ $-input

  total dd 0
  depth dd 0
  garbagetotal dd 0
