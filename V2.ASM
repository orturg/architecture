.model small
.stack 100d
.386
.data
    bytesRead dw ?
    number dw ?
    space db ' ', '$'
    oneChar db ?, '$'
    numbers dw 20000 Dup(?)
    chars db 20000 Dup(?)
    lengthArr dw ?
    newLine db 10, '$'

    
.code
start:
    mov ax, @data
    mov ds, ax

    call Input
    call BubbleSort
    call Mediana

    mov ah, 09h
    lea dx, newLine
    int 21h

    call Average

    mov ah, 09h
    lea dx, newLine
    int 21h

    mov ax, 4C00h
    int 21h
    
Input proc
    xor ax, ax
    xor di, di
    xor si, si

    ;заповнюємо масив чарів нулями
    fillCharWithZeroes:
        mov chars[si], '0'
        add si, 2
        cmp si, 20000
        jbe fillCharWithZeroes  

    xor si, si  


    read_next:
        mov ah, 3Fh
        mov bx, 0h  ; stdin handle
        mov cx, 1   ; 1 byte to read
        mov dx, offset oneChar   ; read to ds:dx 
        int 21h   ;  ax = number of bytes read

        or ax, ax
        je endInput

        cmp oneChar, ' '
        jz putToArray ; якщо прочитує пробіл, то перехід на запис числа

        cmp oneChar, 13 ; CR
        je putToArray
        cmp oneChar, 10 ; LF
        je putToArray

        cmp oneChar, '-'
        je charIsMinus

        jmp putChar

        charIsMinus:
            mov chars[di], '1'
            jmp read_next
        
        putChar:

        mov ax, numbers[di]
        mov cl, oneChar
        
        sub cl, '0' ; отримуємо значення символу з ascii таблиці
        mov bx, 10
        mul bx ;переводимо числа в десяткове
        jo ifOverFlow
        add ax, cx
        jo ifOverFlow

        ; записуємо число в масив
        next:
            mov si, '1'
            mov numbers[di], ax
            jmp read_next
            
        putToArray:
            cmp si, '1' ;перевіряємо на те, чи записаний символ - число
            jnz jump


            cmp chars[di], '1'
            jne nextNum

            neg numbers[di]

            nextNum:
                add di, 2
                mov numbers[di], 0

            jump:
                mov si, '0'
                jmp read_next

        ifOverFlow:
            mov numbers[di], 65535
            jo read_next

    endInput:

    cmp si, '1' 
    jnz putZeroToCheck
    
    add di, 2

    putZeroToCheck:
    xor si, si
    
    ;рахуємо розмір масиву
    calculateLength:
        inc si
        sub di, 2
        cmp di, 0
        ja calculateLength

    ;задаємо розмір масиву 
    setArrayLength:
        mov lengthArr, si
        ret

    Input endp
     

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
                call printSpace
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

    Mediana Proc 

        xor bx, bx 
        xor cx, cx 
        xor ax, ax 
        xor dx, dx 
        xor bl, bl
        mov bl, 0
        mov ax, lengthArr
        mov bx, 2
        div bx
        mov cx, 0
        cmp dx, cx
        je medianaFromTwoNumbers
        jmp medianaFromOneNumber

        medianaFromTwoNumbers: 
        jmp endAndPrint
        xor ax, ax
        xor dx, dx
        mov dx, cx
        xor cx, cx
        goNext:
        add bx, 2
        inc cx
        cmp cx, dx
        jl goNext

        xor ax, ax
        mov ax, numbers[bx]
        add bx, 2 
        add ax, numbers[bx]

        mov bx, 2 
        div bx
        jmp endAndPrint

        medianaFromOneNumber:
        mov dx, ax
        inc dx
        xor ax, ax
        goNextForOneNumber:
        add bx, 2
        inc cx
        cmp cx, dx
        jl goNextForOneNumber

        mov ax, cx 
        jmp endAndPrint

        xor ax, ax
        mov ax, numbers[bx]
        jmp endAndPrint

        endAndPrint:
        call outputNum
        ret 

    Mediana endp

     
  end start
