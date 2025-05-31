include 'emu8086.inc'

.MODEL small

.STACK 4096

.DATA

    message DB 100 DUP(0)
    
    crc_l DB 0FFh 
    
    crc_h DB 0FFh  
    
    polynomial DW 0A001h 
    
    exit_notification   DW 13, 'CRC16 =  $' 
    
    message_2 DB 13, 10, "Enter your text to calculate CRC16: $"  
    
    final_message DB 13, 10, 10, "The program has ended correctly $", 13, 10 
   
    message_3 DB 13, 10, 10, "Continue -> R, exit -> E: $"   
    
    Auxiliary_String DB 13, 10, 'Wrong character! Please try again!', 13, 10, '$' 
    
    
    
.CODE

main PROC 
    
    mov ax, @data 
    
    mov ds, ax  
    
    mov dx,OFFSET  message_2           
    
    mov ah,09h                                 
    
    int 21h 
    
    ;lea SI, message_2
    
    ;call print_string 
    
    ;CALL   pthis 
    
    ;DB  017, 009, 'Enter your text to calculate CRC16 and press ‘Enter’ after the last character: ', 0

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

    mov dx, exit_notification                    

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

    jmp main
    
                                                     
EnteredE:
                   
    mov dx, OFFSET final_message
           
    mov ah,09h                                  
    
    int 21h                              
 
    mov ah,04ch  
                    
    int 21h 

ErrorPressF:

    mov dx,OFFSET Auxiliary_String          

    mov ah,09h                                 

    int 21h  
    
    call next   

next ENDP  

DEFINE_SCAN_NUM  

DEFINE_PRINT_STRING 
                   
DEFINE_PRINT_NUM 

DEFINE_PRINT_NUM_UNS 
 
DEFINE_PTHIS

END main
