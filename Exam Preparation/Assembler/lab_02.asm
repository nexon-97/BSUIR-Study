.model small

.stack
db 256 dup (0)

.data
a dw 120

proc PrintWord
    pusha
           
    mov     dl, 10
    xor     cx, cx
    xor     bx, bx
    
RepeatLoop:    
    div     dl
    mov     bl, ah
    xor     ah, ah
    push    bx
    inc     cx    
    
    cmp     al, 0
    jne     RepeatLoop
       
    mov     ah, 02h
PrintLoop:
    pop     dx
    add     dx, 30h
    int     21h
    loop    PrintLoop  
                     
    popa
    ret
endp

main:
    mov     ax, @data
    mov     ds, ax  
    
    mov     ax, a

    call    PrintWord
    
; getch() analog
    mov     ah, 08h
    int     21h

    mov     ax, 4c00h
    int     21h    
end main