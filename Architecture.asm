.model small
.stack 100h
.data
    input_msg db 10, 13, 'Enter numbers: $'
    space db ' ', '$'
    buffer db 1000 Dup(?)
    numbers dw 5 Dup(?)
    lengthArr dw ?
    filename db 'test.txt', '$' 

    
.code
start:
    mov ax, @data
    mov ds, ax

    mov ax, numbers
    call Input

    mov ax, 4C00h
    int 21h

    Input proc 
        welcomeMessage:
            mov ah, 09h
            lea dx, input_msg
            int 21h ; Виведення повідомлення


            mov ah, 0ah
            xor di, di
            mov dx, offset buffer ; 
            int 21h ; зчитування строки

            mov dl, 0ah
            mov ah, 02
            int 21h ; перехід стрічки
            
            mov si, offset buffer + 2 ; присвоюємо початок буферу лічильнику
        convertNumbers:
            cmp byte ptr [si], "-" ; перевіряємо, чи перший символ -
            jnz ifNotMinus
            inc si    ; пропускаємо -
        ifNotMinus:
            xor ax, ax
            mov bx, 10  ; система числення
        convert :
            mov cl, [si] ; присвоюємо символ з буферу

            cmp cl, 0dh  ; перевірка, чи символ не останній
            jz end
            
            cmp cl, ' ' ; перевіряємо, чи символ не є пробілом
            je addToArray

        
            sub cl, '0' ; переводимо символ у число 
            mul bx     ; перевід в 10
            add ax, cx  
            inc si    
            jmp convert 

            xor cl, cl
            jmp convertNumbers
    
        ; додаємо число до массиву
        addToArray: 
            xor cl, cl
            mov bx, ax
            inc si
            mov numbers[di], ax
            add di, 2
            jmp convertNumbers
    
        ; запис останнього символа в масив, вихід із циклу переводу, задання значення довжини масиву
        end:
            xor cl, cl
            mov numbers[di], ax
            add di, 2
            xor ax, ax
            mov bx, 2
            mov lengthArr, di
            mov ax, lengthArr
            div bx
            mov lengthArr, ax
            xor bx, bx
            ret
    Input endp
    
end start