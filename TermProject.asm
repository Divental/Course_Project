include 'emu8086.inc'

.MODEL small

.STACK 4096

.DATA

    message DB 'A', 0  
    
    crc_l DB 0FFh 
    
    crc_h DB 0FFh  
    
    polynomial DW 0A001h  
    
.CODE

main PROC   
    
    mov ax, @data 
    
    mov ds, ax

    lea si, message

next_byte: 

    lodsb  
    
    cmp al, 0 
    
    je empty_done

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
    
    mov al, crc_l
    
    mov ah, crc_h
    
    call print_num
    
    ret 

    mov ah, 04Ch 
    
    int 21h
    
empty_done:

    mov ah, 04Ch 
    
    int 21h
    
main ENDP

DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS  ; required for print_num.
DEFINE_PTHIS

END main
