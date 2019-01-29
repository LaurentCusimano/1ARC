name "Labyrinthe"



org 100h
           
 




; set video mode    
mov ax, 3     ; text mode 80x25, 16 colors, 8 pages (ah=0, al=3)
int 10h       ; do it!


 jmp game_menu  ;appelle la fonction "game_menu"
game_start_str dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||       sex        fuk assembly8086           sex  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh          
dw '               ||                 XD XD XD XD XD XD                ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                    apui sur un touche o pif      ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh 
dw '               ||           walla je c po pk g fai so              ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh






game_menu:
                                           
    mov ah,09h
    mov dh,0
    mov dx, offset game_start_str ;print mon dessin a la con;
    int 21h
    ; wait for any key press:
    mov ah, 0h
    int 16h
    call clear_screen  
    jmp main_loop
    
    
    
    
main_loop:
      
    
      mov ah, 1h
      int 16h
      jnz key_pressed
      






key_pressed:                              
    mov ah,0h
    int 16h

    cmp ah,48h                            ;go upKey if up button is pressed
    je upKey
    cmp ah, 50h
    je downKey
    
     
                                          ;if no key is pressed go to the main loop
    jmp main_loop
upKey:                                    
    mov ah, 09h
    mov dx, offset msg3
    int 21h
    msg3 db "Keypressed_upkey$" ;affichage de text bug (fait plainter le programme):

downKey:
    mov ah, 09h
    mov dx, offset msg2
    int 21h
    msg2 db "Keypressed_downkey$";affichage de text bug (fait plainter le programme):
    
    
    
    
game_over:
    ret

    
    
    
    
  ;fonction a call pour clear: 
clear_screen proc near
        mov ah,0
        mov al,3
        int 10h        
        ret
clear_screen endp   