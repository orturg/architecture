.model small
.stack 100h
.data
    input_msg db 10, 13, 'Enter numbers: $'
    space db ' ', '$'
    buffer db 1000 Dup(?)
    numbers dw 6 Dup(?)
    lengthArr dw ?
    ; filename db 'file1.txt', '$' 

    
.code
start:
    mov ax, @data
    mov ds, ax

    mov ax, numbers
    call Input
    call BubbleSort
    call Output
    call Average

    mov ax, 4C00h
    int 21h

    Input proc 
        ; welcomeMessage:
        ;     mov ah, 09h
        ;     lea dx, input_msg
        ;     int 21h ; Виведення повідомлення


            mov ah, 0ah
            xor di, di
            mov dx, offset buffer ; 
            int 21h ; зчитування стрічки

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

            cmp cl, 0dh  ; перевірка, чи не символ не останній
            jz inputEnd
            
            cmp cl, ' ' ; перевіряємо, чи символ не є пробілом
            je addToArray

        
            sub cl, '0' ; переводимо символ у число 
            mul bx     ; перевід в 10
            add ax, cx  
            inc si    
            jmp convert     ; повторюємо

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
        inputEnd:
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

     


    Output PROC
        xor dx, dx
        xor ax, ax

        xor di, di
        xor si, si
        mov si, lengthArr
        printingNumbers:
            mov ax, numbers[di]
            call outputNum

            increasingIndex:
            call printSpace
                add di, 2
                dec si
                cmp si, 0
                jbe exit
            loop printingNumbers

        exit:
            ret
    Output endp
     

    outputNum PROC
        firstStep:  
                xor bx, bx
                xor cx, cx
                mov bx, 10 
            secondStep:
                xor dx, dx
                div bx
           
                push dx
                inc cx
            
                test ax, ax
                jnz secondStep

                mov ah, 02h
            thirdStep:
                pop dx
                
                add dl, '0'
                int 21h
                
                loop thirdStep
        ret
    outputNum ENDP

    printSpace PROC
        mov ah, 09h
        lea dx, space
        int 21h
        ret

    printSpace ENDP

    ;Bubble sort
    BubbleSort PROC 
        mov cx, word ptr lengthArr
        dec cx  ; 
    outerLoop:
        push cx
        lea si, numbers
    innerLoop:
        mov ax, [si]
        cmp ax, [si+2]
        jl nextStep
        xchg [si+2], ax
        mov [si], ax
    nextStep:
        add si, 2
        loop innerLoop
        pop cx
        loop outerLoop
        ret
    BubbleSort endp  

  

    Average PROC
        xor bx, bx 
        xor cx, cx 
        xor ax, ax 
        xor dx, dx 

        sumLoop:
        add ax, numbers[bx] 
        add bx, 2
        inc cx 
        cmp cx, lengthArr
        jl sumLoop

        div lengthArr
        call outputNum
        ret 

    Average endp

end start