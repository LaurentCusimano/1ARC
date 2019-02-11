org 100h

include emu8086.inc 

;build 07/02 with menu:
 
Menu:
 
   call CLEAR_SCREEN
  ;affiche le menu:
      
      mov ah,09h
      mov dh,0
      mov dx, offset game_menu_str
      int 21h
  
wait_keypress:
     ;test les key pressed:
    mov ah, 0h
    int 16h                                              
    
    
    cmp al, 112 ;if "p":
    je start_maze_game 

    
    cmp al, 113 ;if "q":
    je give_up

    loop wait_keypress



start_maze_game: 

    call CLEAR_SCREEN
    include "maze_creator_forgame.asm" 
    ;end of maze_creator_forgame = "jmp init_var"
    
init_var:    
    mov sp,1 ;eviter duplication d'evenement key
    mov bp,0 ;variable d'ouverture de porte / si la bonne key
    mov si,0 ;eviter duplication d'evenement door 

    jmp inside_loop

main:
    

    testpos: 
        ;test de position pour l'obtention des objets / ouverture des portes 
        ;besoin de faire un "and" pour verifier la ligne ET la collonne (cette fonction n'est pas complete...
        ;verifie pos pour key1 
        testposkey1:
        
            testlinekey1:
                cmp dh,20
                je testcollumnkey1
                jmp testposdoor1
                
            testcollumnkey1:
                cmp dl,24
                je objectpickup
                jmp testposdoor1 
        
        ;verifie pos pour porte 1
        testposdoor1:
            testlinedoor1:
                cmp dh,17
                je testcollumndoor1
                jmp inside_loop
                
            testcollumndoor1:
                cmp dl,24
                je haskey
                jmp inside_loop
        
        
        
        
        
        
        
       
    
    inside_loop:
    
    
     ;test les key pressed:
    mov ah, 0h
    int 16h                                              
    
    
    cmp al, 115
    je Down 

    
    cmp al, 122
    je Up

    
    cmp al, 113
    je Left

    
    cmp al, 100
    je Right


    
    jmp main
            
 

    Right:
        call clear_player
        ;move cursor to new location
        add dl, 1
        call SetCursor
        ;test colid  
        cmp dx,73
        je testos 
        ;print player to his new location
        PRINT ':)'
        jmp main
        ret
            
    ;a suppr
    testos:
        PRINT 'yees'        
    Left:
      call clear_player
      ;move player to his new location
      sub dl, 1
      call SetCursor
      PRINT '(:'
      jmp main
      ret

   Up:
     call clear_player
     ;move player to his new location
     sub dh, 1
     call SetCursor
     PRINT ':)'
     jmp main
     ret

   Down:
      call clear_player
      ;move player to his new location
      add dh, 1
      call SetCursor
      PRINT ':)'
      jmp main
      ret

   SetCursor:
       mov ah, 02h
       mov bh, 00
       int 10h
       ret
   objectpickup:
   
        cmp sp,1
        je key1pickup
        
        jmp inside_loop
        key1pickup:
            mov dl,62
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You found a key' 
            ;stock cette info dans une variable:
            mov bp,1
            ;met a jour "si" pour pouvoir ressayer d'ouvrir la porte associer:
            mov si,0
            ;remet le cursor a sa position d'origine:
            mov dl,24;pas la position d'origine pour eviter d'effacer le mur:
            mov dh,20
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
            mov sp,2
            jmp inside_loop 
   haskey:
        
        cmp si,0
        je testkey 
        
        
        
        jmp inside_loop
        testkey:
            cmp bp,1
            je opendoor
            
            mov si,1
            
        display_nokeymessage:
        
            call clear_oldmessage
          
            mov dl,62
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
          
            PRINT 'you have no key'
          
          
            ;remet le cursor a sa position d'origine:
            mov dl,25 ;pas la position d'origine pour eviter d'effacer la porte:
            mov dh,17
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            jmp inside_loop      
   opendoor:
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h
          
          PRINT 'a door'
          
          ;avance "si":
          mov si,2
          ;remet le cursor a sa position d'origine:
          mov dl,25  ;pas la position d'origine pour eviter d'effacer la porte:
          mov dh,17
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h
          
          
   ;commande a ajouter dans la fonction de la derniere porte (pour gagner):
          jmp win
          jmp inside_loop
    
  
  
  
   give_up:
        call CLEAR_SCREEN
        mov dl,22
        mov dh,10 
        mov ah, 02h
        mov bh, 00
        int 10h       
        
        PRINT 'You give up...:('
        ADD dh ,1
        mov ah, 02h
        mov bh, 00
        int 10h
        
        PRINT 'press any key to exit maze_game'
        mov ah, 0h
        int 16h                                              
        jmp theEND
   
   win:
        call CLEAR_SCREEN
        mov dl,22
        mov dh,10 
        mov ah, 02h
        mov bh, 00
        int 10h       
        
        PRINT 'You beat the maze :D awesome!'
        ADD dh ,1
        sub dl,8
        mov ah, 02h
        mov bh, 00
        int 10h
        
        PRINT 'press p key to go back on the menu'
        
        add dh,1
        add dl,16 
        mov ah, 02h
        mov bh, 00 
        int 10h
        
        PRINT 'Or press any other key to quit the game'
        
        
        
            ;test les key pressed:
            mov ah, 0h
            int 16h                                              
    
    
            cmp al, 112 ;if "p":
            je Menu 

            jmp theEND

           
                                                    
        
     
    
    
  
   clear_oldmessage proc near
        mov dl,62
        mov dh,6 
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '               '
        sub dh,1
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '               '
        ret
       
               
    clear_oldmessage endp
     
     
   
   
   
   
   clear_player proc near
    ;delete last player position 
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '  '       
        ret
        
    clear_player endp  
   
   
   
   
   game_menu_str dw '  ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                 __  __                  _____                ',0ah,0dh       
dw '                |  \/  |                / ____|               ',0ah,0dh       
dw '                | \  / | __ _ _______  | |  __  __ _ _ __ ___   ___    ',0ah,0dh
dw '                | |\/| |/ _` |_  / _ \ | | |_ |/ _  |  _   _ \ / _ \   ',0ah,0dh
dw '                | |  | | (_| |/ /  __/ | |__| | (_| | | | | | |  __/   ',0ah,0dh
dw '                |_|  |_|\__ _/___\___|  \_____|\__ _|_| |_| |_|\___|   ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '            |---------------------------||---------------------------|  ',0ah,0dh
dw '            | ^   Press "p" to play   ^ || ^   Press "q" to quit   ^ | ',0ah,0dh
dw '            |___________________________||___________________________|',0ah,0dh

dw '$',0ah,0dh
       
       
       theEnd: 
       
       
       DEFINE_CLEAR_SCREEN
       
       
       
         
       END