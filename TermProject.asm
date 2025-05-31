.MODEL small

.STACK 4096

.DATA

    message DB 'ABC', 0  
    
    crc_l DB 0FFh 
    
    crc_h DB 0FFh  
    
    polynomial DW 0A001h 
    
    exit_notification   DW 13, 10, 10, 10, 10, 'CRC16 =  $' 
    
.CODE

main PROC   
    
    mov ax, @data 
    
    mov ds, ax

    lea si, message

next_byte: 

    lodsb  
    
    cmp al, 0 
    
    je done

    xor al, crc_l  
    
    mov crc_l, al

    mov cx, 8

bit_loop:   

    mov ax, 0  
         
    mov al, crc_l  
    
    mov ah, crc_h  
    
    shr ax, 1        

    jc xor_polynomial   
     
    jmp store_crc

xor_polynomial:

    xor ax, polynomial

store_crc:

    mov crc_l, al
    
    mov crc_h, ah

    loop bit_loop 
    
    jmp next_byte

done:

    mov    dx, exit_notification                    

    mov    ah,09h                                       

    int       21h 
    
    mov al, crc_h   
    
    call print_hex_byte

    mov al, crc_l 
    
    call print_hex_byte

    mov ah, 4Ch 
    
    int 21h

print_hex_byte:  

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

print_hex_digit: 

    cmp al, 9 
    
    jbe print_num 
    
    add al, 7  
          
print_num:  

    add al, '0' 
    
    mov dl, al  
                 
    mov ah, 02h  
    
    int 21h 
    
    ret
    
main ENDP

END main
