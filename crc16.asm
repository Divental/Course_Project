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

read_loop:  

    mov ah, 1 
          
    int 21h   
    
    cmp al, 13      
    
    je input_done     
    
    mov [di], al     
    
    inc di      
    
    jmp read_loop

input_done:  

    mov byte ptr [di], 0    

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

    mov dx, OFFSET exit_notification                    

    mov ah,09h                                       

    int 21h 
    
    mov al, crc_h   
    
    call print_hex_byte

    mov al, crc_l 
    
    call print_hex_byte 
    
    call next


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
    
    jbe outer_print_num 
    
    add al, 7  
          
outer_print_num:  

    add al, '0' 
    
    mov dl, al  
                 
    mov ah, 02h  
    
    int 21h 
    
    ret
    
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
                             
           
EnteredC:

    call clear_away

    jmp main
                                                       
EnteredE:
                   
    mov dx, OFFSET final_message
           
    mov ah,09h                                  
    
    int 21h                              
 
    mov ah,04ch  
                    
    int 21h 

ErrorPressF:

    mov dx,OFFSET auxiliary_string          

    mov ah,09h                                 

    int 21h  
    
    call next   

next ENDP

clear_away PROC

    mov cx, 10         
    
    lea di, message   

clear_loop:      
    
    mov byte ptr [di], 0  
    
    inc di  
    
    loop clear_loop  
    
    ret

clear_away ENDP        

END main
