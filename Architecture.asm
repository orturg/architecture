.model small
.stack 100h

.data
    input_msg db 10, 13, 'Enter numbers: $'
    output_msg db 10, 13, 'You entered: $'
    buffer db 255, ?, 255 dup('$') ; буфер для зберігання введеного рядка

.code
    main PROC
        mov ax, @data
        mov ds, ax

        ; Просимо у користувача ввести числа
        mov ah, 09h
        lea dx, input_msg
        int 21h

        ; Зчитуємо введений рядок
        mov ah, 0Ah
        lea dx, buffer
        int 21h

        ; Виводимо повідомлення про введений рядок
        mov ah, 09h
        lea dx, output_msg
        int 21h

        ; Виводимо введений рядок
        mov ah, 09h
        lea dx, buffer+2 
        int 21h

        mov ah, 4Ch    ; вихід із програми
        int 21h
    main ENDP

END main

