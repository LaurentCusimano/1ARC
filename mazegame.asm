name "MazeGame"

org 100h

include emu8086.inc 


  CURSOROFF;comme son noms l'indique desactive la vue du cursor (marche avec "emu8086.inc")   
Menu:
 
   call CLEAR_SCREEN
  ;affiche le menu:
      call set_background_color
      mov ah,09h
      mov dh,0
      mov dx, offset game_menu_str
      int 21h
      
;starting of the anim:
mov dh,14
mov dl,30
play_menu_anim:
mov AnimControl,1;use "AnimControl" to know which animation to play:
cmp dl,40
je inverted_menu_anim 

add dl,1
mov ah, 02h
mov bh, 00
int 10h
PRINT ':)'
jmp wait_keypress
inverted_menu_anim:
mov AnimControl,2
cmp dl,30
je play_menu_anim 

sub dl,1
mov ah, 02h
mov bh, 00
int 10h
PRINT '(:'


  
wait_keypress:
     ;test les key pressed:
    mov ah, 1h
    int 16h                                              
    
    
    cmp al, 13 ;if "enter":
    je start_maze_game 

    
    cmp al, 27 ;if "ecs":
    je give_up
    call clear_player
    cmp AnimControl,1
    je play_menu_anim
    cmp AnimControl,2
    je inverted_menu_anim
    



start_maze_game: 

    call CLEAR_SCREEN
    call set_background_color
    include "maze.asm" 
    ;end of maze_creator_forgame = "jmp init_var"
          
init_var:
    ColliderDetected DB 'n';passe a 'y' si une collision est detecte
    Event_door Dw 1 ;eviter duplication d'evenement door
    Event_key Dw 1 ;(peut ne plus etre necessaire);eviter duplication d'evenement key
    whichKey Dw 0;variable d'ouverture de porte / si la bonne key
    AnimControl Dw 0;variable utiliser pour l'annimation du menu
    jmp inside_loop

main: 
  ;test de position pour l'obtention des objets / ouverture des portes 
    testpos: 
                
            
          jmp canposkey2  
     
           redkeytest:
                cmp Event_door,1
                je has_redkey
                jmp CollidYes
                
                   has_redkey:

                        cmp whichKey,1
                        je opendoor1
                        jmp display_nokeymessage
                        ret 
                  
                
        ;verifie si key2 est apparu:
        canposkey2:
            cmp whichKey,1
            je testlinekey2
            jmp testlinedoor2           
        ;verifie pos pour key2 
        testposkey2:
        
            testlinekey2:
                cmp dh,20
                je testcollumnkey2
                jmp testposdoor2
                
            testcollumnkey2:
                cmp dl,27
                je key2pickup
                jmp testposdoor2 
        
        ;verifie pos pour porte 1
        testposdoor2:
            testlinedoor2:
                cmp dh,17
                je testcollumndoor2
                jmp inside_loop
                
            testcollumndoor2:
                cmp dl,30
                je bluekeytest
                jmp inside_loop
                
                
            bluekeytest:
                cmp Event_door,2
                je has_bluekey
                jmp inside_loop
                
                has_bluekey:
            
                    cmp whichKey,2
                    je opendoor2            
                    jmp display_nokeymessage
        
                         
            
    
  
        
        
        
        
        
        
       
    
    inside_loop:
    ;clear_collidervar:
    mov ColliderDetected,'n' 
    
     ;test les key pressed:
    mov ah, 0h
    int 16h                                              
    
    ;controls with ZQSD                  
    cmp al, 115  ;if "s"
    je Down 

    
    cmp al, 122  ;if "z"
    je Up

    
    cmp al, 113   ;if "q"
    je Left

    
    cmp al, 100   ;if "d"
    je Right

  
    
    jmp main
            
 

    Right:
        ;move cursor to new location
        add dl, 2
        call SetCursor
        call TestColid
        sub dl,2
        call SetCursor
        cmp ColliderDetected,'y'
        je main
        call clear_player
        add dl,1
        call SetCursor
        mov bh, 0
            mov ah, 0x2
            int 0x10
            mov cx, 2 ; nb char
            mov bh, 0
            mov bl, 0x19 ; color
            mov al, 0x20 ; blank char
            mov ah, 0x9
            int 0x10 
            mov ah, 02h
            mov bh, 00
            int 10h
                  
        PRINT ':)'
        jmp main
        ret
            
         
    Left:
      ;move player to his new location
      sub dl, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      PRINT '(:'
      cmp ColliderDetected,'y'
      je main
      call clear_player
      sub dl,1
      call SetCursor
      mov bh, 0
            mov ah, 0x2
            int 0x10
            mov cx, 2 ; nb char
            mov bh, 0
            mov bl, 0x19 ; color
            mov al, 0x20 ; blank char
            mov ah, 0x9
            int 0x10 
            mov ah, 02h
            mov bh, 00
            int 10h
                  
      PRINT '(:'
      jmp main
      ret

   Up:
     ;move player to his new location
      sub dh, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      call TestColid
      sub dl,1      
      add dh,1
      call SetCursor
      cmp ColliderDetected,'y'
      je main
      call clear_player
      sub dh,1
      call SetCursor
      mov bh, 0
            mov ah, 0x2
            int 0x10
            mov cx, 2 ; nb char
            mov bh, 0
            mov bl, 0x19 ; color
            mov al, 0x20 ; blank char
            mov ah, 0x9
            int 0x10 
            mov ah, 02h
            mov bh, 00
            int 10h
                  
       PRINT ':)'
      jmp main
      ret

   Down:
      ;move player to his new location
      add dh, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      call TestColid
      sub dl,1  
      sub dh,1
      call SetCursor
      cmp ColliderDetected,'y'
      je main
      call clear_player
      add dh,1
      call SetCursor
      mov bh, 0
            mov ah, 0x2
            int 0x10
            mov cx, 2 ; nb char
            mov bh, 0
            mov bl, 0x19 ; color
            mov al, 0x20 ; blank char
            mov ah, 0x9
            int 0x10 
            mov ah, 02h
            mov bh, 00
            int 10h
                  
        PRINT ':)'
      jmp main
      ret

   SetCursor:
       mov ah, 02h
       mov bh, 00
       int 10h
       ret
   TestColid:
       mov ah, 08h
       int 10h
       
       cmp al,206 
       je CollidYes
       
       cmp al,188 
       je CollidYes
       
       cmp al,203 
       je CollidYes
       
       cmp al,187 
       je CollidYes
       
       cmp al,200 
       je CollidYes
       
       cmp al,201 
       je CollidYes 
       
       cmp al,204 
       je CollidYes
       
       cmp al,200 
       je CollidYes
       
       cmp al,202 
       je CollidYes
       
       cmp al,185  
       je CollidYes
       ;mur horizontal
       cmp al,205 
       je CollidYes
       
       ;mur vertical
       cmp al,186 
       je CollidYes 
       
       
       
       ;door
       cmp al,177 
       je redkeytest
       
       ;key
       cmp al,216 
       je objectpickup       
       
       cmp ah,40
       je testos
       ret
     testos:
     PRINT 'YEEES'
     ret  
    CollidYes:
        mov ColliderDetected,'y'
        ret
     
   objectpickup:
        key1check:
            cmp Event_key,1
            je key1pickup
           
        key2check:
            cmp Event_key,2
            je key2pickup
            
         
        
        ret
        key1pickup:
            call clear_oldmessage
            mov dl,62
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            PRINT ' a redkey'
             
            ;stock cette info dans une variable:
            mov whichKey,1
            ;met a jour "Event_door" pour pouvoir ressayer d'ouvrir la porte associer:
            mov Event_door,1
            call UpdateInv ;pour mettre a jour l'inventaire:
            ;remet le cursor a sa position d'origine:
            mov dl,13;pas la position d'origine pour eviter d'effacer le mur:
            mov dh,21
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
            mov Event_key,2
            ret
            
         key2pickup:
            call clear_oldmessage
            mov dl,62
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            PRINT ' a bluekey' 
            ;stock cette info dans une variable:
            mov whichKey,2
            ;met a jour "Event_door" pour pouvoir ressayer d'ouvrir la porte associer:
            mov Event_door,2 
            call UpdateInv
            ;remet le cursor a sa position d'origine:
            mov dl,27;pas la position d'origine pour eviter d'effacer le mur:
            mov dh,20
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
            mov Event_key,3
            jmp inside_loop 
 
                 
        display_nokeymessage:
        
            call clear_oldmessage
            mov Event_door,99
            mov dl,62
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
          
            PRINT 'wrong key'
            mov dl,62
            mov dh,7
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            PRINT ' or nokey'
          
          
            ;remet le cursor a sa position d'origine:
            mov dl,13 ;pas la position d'origine pour eviter d'effacer la porte:
            mov dh,17                                         
            mov ah, 02h
            ;setcursor:
            mov bh, 00
            int 10h
            
            ret
                  
   opendoor1:
          call clear_player
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
          
          PRINT 'red door'
          
          ;avance "Event_door" a 1 pour pouvoir tester la porte bleu:
          mov Event_door,2
          
          ;draw blue key:
            draw_bluekey:
                mov dl,28
                mov dh,20
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x10 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 216
            
          ;remet le cursor a sa position d'origine:
          mov dl,13  
          mov dh,17
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h 
          jmp inside_loop
          
     opendoor2:
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
          
          PRINT 'blue door'
          
          ;avance "Event_door":
          mov Event_door,3
          ;remet le cursor a sa position d'origine:
          mov dl,28  ;pas la position d'origine pour eviter d'effacer la porte:
          mov dh,17
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h     
          
   ;commande a ajouter dans la fonction de la derniere porte (pour gagner):
          jmp win
          
    
  
  
  
   give_up:
        call CLEAR_SCREEN
        call set_background_color
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
        call set_background_color
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
        
        PRINT 'press ENTER key to go back on the menu'
        
        add dh,1
        add dl,16 
        mov ah, 02h
        mov bh, 00 
        int 10h
        
        PRINT 'Or press any other key to quit the game'
        
        
        
            ;test les key pressed:
            mov ah, 0h
            int 16h                                              
    
    
            cmp al, 13 ;if "enter":
            je Menu 

            jmp theEnd

           
                                                    
        
   
    
   theEnd:
   clear_oldmessage proc near
        mov dl,62
        mov dh,6 
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '               '
        add dh,1
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '               '
        ret
       
               
    clear_oldmessage endp
     
     
   
   
   UpdateInv proc near
     testhavekey1:
             cmp whichKey,1
             je Draw_on_key1
             jmp testhavekey2
             Draw_on_key1:
             ;ajoute de la couleur a la clef debloquer
             mov dl,65
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x40 ; color
             mov al, 0x20 ; blank char
             mov ah, 0x9
             int 0x10 
             mov ah, 02h
             mov bh, 00
             int 10h       
             PRINT 216
             jmp end_UpdateInv
     
     testhavekey2:
             cmp whichKey,2
             je Draw_on_key2
             jmp end_UpdateInv
             Draw_on_key2:
             ;ajoute de la couleur a la clef debloquer
             mov dl,67
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x10 ; color
             mov al, 0x20 ; blank char
             mov ah, 0x9
             int 0x10 
             mov ah, 02h
             mov bh, 00
             int 10h       
             PRINT 216        
             
              
             end_UpdateInv:    
             ret
        
    UpdateInv endp
   
   clear_player proc near
    ;delete last player position 
        
            mov bh, 0
            mov ah, 0x2
            int 0x10
            mov cx, 2 ; nb char
            mov bh, 0
            mov bl, 0x19 ; color
            mov al, 0x20 ; blank char
            mov ah, 0x9
            int 0x10 
            mov ah, 02h
            mov bh, 00
            int 10h
                  
        PRINT '  '       
        ret
        
    clear_player endp 
   
   set_background_color proc near
    mov dx, 0 ; Set cursor to top left-most corner of screen
    mov bh, 0
    mov ah, 0x2
    int 0x10
    mov cx, 2024 ; print 2000 chars
    mov bh, 0
    mov bl, 0x19 ; color
    mov al, 0x20 ; blank char
    mov ah, 0x9
    int 0x10       
        ret
        
    set_background_color endp
   
   
   
   
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
dw '            | ^ Press "enter" to play ^ || ^   Press "ecs" to quit ^ | ',0ah,0dh
dw '            |___________________________||___________________________|',0ah,0dh

dw '$',0ah,0dh
       
       
        
       
       
       DEFINE_CLEAR_SCREEN
       DEFINE_PRINT_NUM 
       DEFINE_PRINT_NUM_UNS 
       
       END