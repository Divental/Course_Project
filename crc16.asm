.MODEL small

.STACK 4096

.DATA

    message DB 10 DUP(0)   
    
    crc_l DB 0FFh 
    
    crc_h DB 0FFh  
    
    polynomial DW 0A001h 
    
    exit_notification DB 10, 13, 10, 'CRC16 = $' 
    
    message_2 DB 10, 13, 10, "Enter your text to calculate CRC16: $"  
    
    message_3 DB 10, 13, 10, "{ Continue -> C (Upper case) }---/\---{ Exit -> E (Upper case) }: $"  
    
    final_message DB 10, 13, 10, "The program has ended correctly! $"
    
    auxiliary_string DB 10, 13, 10, 'Wrong character! Please try again!', 13, 10, '$'    
 
   
.CODE

main PROC 
    
    mov ax, @data 
    
    mov ds, ax 
    
    mov crc_l, 0FFh          
    
    mov crc_h, 0FFh 
    
    mov dx,OFFSET  message_2           
    
    mov ah,09h                                 
    
    int 21h 

    lea di, message


; This code reads characters from the keyboard one by one into the message buffer until the Enter key (code 13) is pressed, after which it terminates the input.
read_loop:  

    mov ah, 1 
          
    int 21h   
    
    cmp al, 13      
    
    je input_done     
    
    mov [di], al     
    
    inc di      
    
    jmp read_loop


; This code places a zero (0) byte at the end of the entered string (to mark the end of the text) and loads the start address of the message string into the SI register for further processing.
input_done:  

    mov byte ptr [di], 0    

    lea si, message


; Reads one character at a time from the line, checks the end, and starts processing for CRC16.
next_byte: 

    lodsb  
    
    cmp al, 0 
    
    je done

    xor al, crc_l  
    
    mov crc_l, al

    mov cx, 8
 
 
; Shifts the CRC one bit to the right and, if the shift causes a carry (overflow), proceeds to the XOR operation with the polynomial to update the CRC.
bit_loop:   

    mov ax, 0  
         
    mov al, crc_l  
    
    mov ah, crc_h  
    
    shr ax, 1        

    jc xor_polynomial   
     
    jmp store_crc


; Performs XOR between register AX (current CRC) and the specified polynomial 0A001h if there was a carry during the shift.
xor_polynomial:

    xor ax, polynomial


; Stores the updated CRC value in crc_l and crc_h, repeats the cycle for the next bit, and after 8 bits moves on to processing the next character.
store_crc:

    mov crc_l, al
    
    mov crc_h, ah

    loop bit_loop 
    
    jmp next_byte


; Displays the message CRC16 =, then sequentially displays the most significant (crc_h) and least significant (crc_l) bytes of the calculated CRC in hexadecimal format, after which it proceeds to select an action (continue or exit).
done:

    mov dx, OFFSET exit_notification                    

    mov ah,09h                                       

    int 21h 
    
    mov al, crc_h   
    
    call print_hex_byte

    mov al, crc_l 
    
    call print_hex_byte 
    
    call next


; The print_hex_byte procedure displays the contents of the AL register in hexadecimal format (2 characters) on the screen.
print_hex_byte PROC  

    push ax 
    
    push bx

    mov bl, al  
          
    shr al, 4  
           
    call print_hex_digit

    mov al, bl  
    
    and al, 0Fh      
    
    call print_hex_digit

    pop bx 
    
    pop ax 
    
    ret 

print_hex_byte ENDP


; The print_hex_digit procedure displays a single hexadecimal character (0–9, A–F) passed in the AL register on the screen.
print_hex_digit PROC 

    cmp al, 9 
    
    jbe outer_print_num 
    
    add al, 7  

          
outer_print_num:  

    add al, '0' 
    
    mov dl, al  
                 
    mov ah, 02h  
    
    int 21h 
    
    ret 

print_hex_digit ENDP


; Processes user input for repeat or exit, clears the screen, displays a message, and proceeds according to the selection (C - repeat, E - exit, other error).    
next PROC 
    
    call clear_away

    mov dx,OFFSET message_3         
    
    mov ah,09h                                 
    
    int 21h                
    
    mov ah,01h                                  
    
    int 21h

    cmp al,'C'
    
    jz EnteredC
    
    cmp al,'E'
    
    jz EnteredE  
    
    jnz ErrorPressF

                             
; If the user enters ‘C’, clears the input buffer and restarts the program from the beginning.           
EnteredC:

    call clear_away

    jmp main

; If the user enters ‘E’, displays a farewell message and terminates the program via interrupt int 21h with function 4Ch.                                                       
EnteredE:
                   
    mov dx, OFFSET final_message
           
    mov ah,09h                                  
    
    int 21h                              
 
    mov ah,04ch  
                    
    int 21h 


; If an incorrect character is entered, displays an error message and restarts the action selection via next.
ErrorPressF:

    mov dx,OFFSET auxiliary_string          

    mov ah,09h                                 

    int 21h  
    
    call next   

next ENDP


; Clears the message array of 10 bytes, writing a zero (0) to each one.
clear_away PROC

    mov cx, 10         
    
    lea di, message   


; Cyclically writes zero (0) to each byte of the message buffer, clearing it completely.
clear_loop:      
    
    mov byte ptr [di], 0  
    
    inc di  
    
    loop clear_loop  
    
    ret

clear_away ENDP        



END main
