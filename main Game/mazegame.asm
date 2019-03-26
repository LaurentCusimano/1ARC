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
    
    ;include "maze_test.asm" 
    include "maze_part1.asm" 
     maze_part2:
     
     include "maze_part2.asm" 
   
   
          
init_var:
    ColliderDetected DB 'n';passe a 'y' si une collision est detecte
    
    IsGreen DB 'n';passe a 'y' si la clef verte est rammasse
    
        
    EE_eggs Dw 0 ;nombre d'oeuf rammasser
   
    Event_key Dw 1 ;(peut ne plus etre necessaire);eviter duplication d'evenement key
    mov Event_key,1
    whichKey Dw 0;variable d'ouverture de porte / si la bonne key
    mov whichKey,0 
    AnimControl Dw 0;variable utiliser pour l'annimation du menu
    mov AnimControl,0 
    MovesCount Dw 0;store how many moves that you make in the game
    mov MovesCount,0
    
    ;stock la derniere position du joueur
    DhPlayer Db 1
    DlPlayer Db 1
    
    mov dl, 2 ; column
    mov dh, 21 ; row
    
    
    jmp inside_loop

main: 
  
      
    
     
       
    
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

      ;controls with arrows                  
    
   cmp ah, 50h  ;if downarrow
    je Down 

    
    cmp ah, 48h   ;if uparrow
    je Up

    
    cmp ah, 4Bh  ;if leftarrow
    je Left

    
    cmp ah, 4Dh  ;if rightarrow
    je Right
    
    ;other
    cmp al, 27 ;if "ecs":
    je give_up
    
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
        add MovesCount,1          
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
      add MovesCount,1
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
       add MovesCount,1
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
        add MovesCount,1
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
       
       ;EEguy
       cmp al,001 
       je EasterEgg_Activate
       
       ;door
       cmp al,177 
       je keytest
       
        eggs:
        cmp al,248
        je eggs_collected 
       
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
    
     eggs_collected:
     
     
    
      add EE_eggs,1 
      
      
      call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT 'an egg :D'
             
            
            call Load_PlayerLoc
      
      
      
      cmp EE_eggs,13
      je win_EE
      ret
    EasterEgg_Activate:
     call CollidYes
     call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'Hello can u'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT 'Find my eggs?:P'
             
            include "EE.asm"
            call Load_PlayerLoc
            ret
     
   
    keytest:
            nokeytest:
            cmp whichKey,0
            je display_nokeymessage
            jmp redkeytest   
          
     
           redkeytest:
                
                        cmp whichKey,1
                        je opendoor1
                        jmp bluekeytest
                         
                  
                
       
                
            bluekeytest:
                
            
                    cmp whichKey,2
                    je opendoor2            
                    jmp yellowkeytest
        
                         
               yellowkeytest:
                
            
                    cmp whichKey,3
                    je opendoor3            
                    
                    jmp OrangeAndGreenkeytest
                    
                    
              OrangeAndGreenkeytest:
                
            
                    cmp whichKey,4
                    je GreenOrOrange
                    
                    cmp whichKey,5
                    je GreenOrOrange 
                    jmp havenokey           
                    
                    GreenOrOrange:
                    
                    cmp dl,60
                    je isthatgreen
                    jmp opendoor4
                    
                    isthatgreen:
                    cmp IsGreen,'y'
                    je opendoor5
                    
                    
                    
                    
                    jmp display_nokeymessage
                    havenokey:
                    ret
   
   
   
   
   objectpickup:
        key1check:
            cmp Event_key,1
            je key1pickup
           
        key2check:
            cmp Event_key,2
            je key2pickup
        key3check:
            cmp Event_key,3
            je key3pickup
            
        key4check:
            cmp Event_key,4
            je key4pickup
            
            
            
        key5check:
            cmp Event_key,5
            je key5pickup    
         
        
        ret
        key1pickup:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a redkey'
             
            ;stock cette info dans une variable:
            mov whichKey,1
            call UpdateInv ;pour mettre a jour l'inventaire:
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,2
            ret
            
         key2pickup:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a pinkkey' 
            ;stock cette info dans une variable:
            mov whichKey,2
            call UpdateInv
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,3
            ret
 
            
         key3pickup:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a bluekey' 
            ;stock cette info dans une variable:
            mov whichKey,3
            call UpdateInv
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,4
            ret
            
            
            key4pickup:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a Orangekey' 
            ;stock cette info dans une variable:
            mov whichKey,4
            call UpdateInv
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,5
            ret 
            
            key5pickup:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a Greenkey' 
            ;stock cette info dans une variable:
            mov whichKey,5
            mov IsGreen,'y' ; indique que la green key a �t� rammaser
            call UpdateInv
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,6
            ret
                    
        display_nokeymessage:
        
            call CollidYes
            ;ret ; display_nokeymessage desactiver en attente de mise a jour:
            call Save_PlayerLoc
            call clear_oldmessage
            mov dl,62
            mov dh,6
            call SetCursor
          
            PRINT 'wrong key'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' or nokey'
          
          
            ;remet le cursor a sa position d'origine:
            call Load_PlayerLoc                                        
            mov ah, 02h
            call SetCursor
            
            ret
                  
   opendoor1:
          call Save_PlayerLoc
          ;call clear_player
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          call SetCursor 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          call SetCursor
          
          PRINT 'red door'
          
         
          mov whichKey,0
          
          ;draw purple key:
            draw_purplekey:
                mov dl,17
                mov dh,12
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x50 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 216
            
          ;remet le cursor a sa position d'origine:
          call Load_PlayerLoc
          call SetCursor
          ret 
          jmp inside_loop
          
     opendoor2:
          call Save_PlayerLoc
          call clear_player
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          call SetCursor 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          call SetCursor
          
          PRINT 'pink door'
          
         
          mov whichKey,0
          ;draw yellow key:
            draw_bluekey:
                mov dl,14
                mov dh,12
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x30 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 216
          ;remet le cursor a sa position d'origine:
          call Load_PlayerLoc
          call SetCursor
          ret     
          jmp inside_loop
          
          
        opendoor3:
          call Save_PlayerLoc
          call clear_player
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          call SetCursor 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          call SetCursor
          
          PRINT 'blue door'
          
          
          mov whichKey,0
          ;draw orrange key:
            draw_orangekey:
                mov dl,38
                mov dh,13
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x60 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 216
          ;remet le cursor a sa position d'origine:
          call Load_PlayerLoc
          call SetCursor     
          ret
          
          opendoor4:
          call Save_PlayerLoc
          call clear_player
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          call SetCursor 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          call SetCursor
          
          PRINT 'Orange door'
          
          
          mov whichKey,0
          ;draw orrange key:
            draw_Greenkey:
                mov dl,60
                mov dh,16
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x20 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 216
          ;remet le cursor a sa position d'origine:
          call Load_PlayerLoc
          call SetCursor     
          ret
          
          opendoor5:
          call Save_PlayerLoc
          call clear_player
          call clear_oldmessage
          
          mov dl,62
          mov dh,6
          call SetCursor 
          
          PRINT 'you have open'
          mov dl,62
          mov dh,7
          call SetCursor 
          
          PRINT 'Green door'
         
                    
          ;commande a ajouter dans la fonction de la derniere porte (pour gagner):
          jmp win
          
          
  
  
  
   give_up:
        call CLEAR_SCREEN
        call set_background_color
        mov ah,09h
        mov dh,0
        mov dx, offset Give_up_str
        int 21h
        mov dl,22
        mov dh,10 
        mov ah, 02h
        mov bh, 00
        int 10h       
        
        PRINT 'You gave up...:('
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
        mov ah,09h
        mov dh,0
        mov dx, offset win_str
        int 21h
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
        
        
                            
            
         mov dl,26
         mov dh,15
         call SetCursor
         
         PRINT 'you move '
        MOV ax,MovesCount
  

       
            call PRINT_NUM   
            
             PRINT 'times'
            
            
            ;test les key pressed:
            mov ah, 0h
            int 16h                                              
    
    
            cmp al, 13 ;if "enter":
            je Menu 

            jmp theEnd

           
    win_EE: 
    
    call CLEAR_SCREEN
        call set_background_color
        mov ah,09h
        mov dh,0
        mov dx, offset win_EE_str
        int 21h
        mov dl,22
        mov dh,10 
        mov ah, 02h
        mov bh, 00
        int 10h       
        
        PRINT 'You find all the eggs :D awesome!'
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
        
        
                            
            
         mov dl,26
         mov dh,15
         call SetCursor
         
         PRINT 'you move '
        MOV ax,MovesCount
  

       
            call PRINT_NUM   
            
             PRINT 'times'
            
            
            ;test les key pressed:
            mov ah, 0h
            int 16h                                              
    
    
            cmp al, 13 ;if "enter":
            je Menu 

            jmp theEnd                                               
        
   
    
   
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
     
   Save_PlayerLoc proc near
    
     mov DhPlayer,dh
     mov DlPlayer,dl
       
        ret
       
               
    Save_PlayerLoc endp 
   
   Load_PlayerLoc proc near
    
     mov dh,DhPlayer
     mov dl,DlPlayer
       
        ret
       
               
    Load_PlayerLoc endp 
   
   
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
             jmp testhavekey3
             Draw_on_key2:
             ;ajoute de la couleur a la clef debloquer
             mov dl,67
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x50 ; color
             mov al, 0x20 ; blank char
             mov ah, 0x9
             int 0x10 
             mov ah, 02h
             mov bh, 00
             int 10h       
             PRINT 216        
             jmp end_UpdateInv
        testhavekey3:
             cmp whichKey,3
             je Draw_on_key3
             jmp testhavekey4
             Draw_on_key3:
             ;ajoute de la couleur a la clef debloquer
             mov dl,69
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x30 ; color
             mov al, 0x20 ; blank char
             mov ah, 0x9
             int 0x10 
             mov ah, 02h
             mov bh, 00
             int 10h       
             PRINT 216
             
           testhavekey4:
             cmp whichKey,4
             je Draw_on_key4
             jmp testhavekey5
             Draw_on_key4:
             ;ajoute de la couleur a la clef debloquer
             mov dl,71
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x60 ; color
             mov al, 0x20 ; blank char
             mov ah, 0x9
             int 0x10 
             mov ah, 02h
             mov bh, 00
             int 10h       
             PRINT 216
             
           testhavekey5:
             cmp whichKey,5
             je Draw_on_key5
             jmp end_UpdateInv
             Draw_on_key5:
             ;ajoute de la couleur a la clef debloquer
             mov dl,73
             mov dh,4
             mov bh, 0
             mov ah, 0x2
             int 0x10
             mov cx, 1 ; nb char
             mov bh, 0
             mov bl, 0x20 ; color
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

win_str dw '  ',0ah,0dh

dw '      _____  _____  __          _______          ',0ah,0dh
dw '     / ____|/ ____| \ \        / /  __ \         ',0ah,0dh
dw '    | |  __| |  __   \ \  /\  / /| |__) |        ',0ah,0dh
dw '    | | |_ | | |_ |   \ \/  \/ / |  ___/         ',0ah,0dh
dw '    | |__| | |__| |    \  /\  /  | |             ',0ah,0dh
dw '     \_____|\_____|     \/  \/   |_|             ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh                                      
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '           \(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh

dw '$',0ah,0dh
         
   win_EE_str dw '  ',0ah,0dh
   
dw '      _____  _____  __          _______          ',0ah,0dh
dw '     / ____|/ ____| \ \        / /  __ \         ',0ah,0dh
dw '    | |  __| |  __   \ \  /\  / /| |__) |    	.-"-. ',0ah,0dh
dw '    | | |_ | | |_ |   \ \/  \/ / |  ___/       ./=^=^=\. ',0ah,0dh
dw '    | |__| | |__| |    \  /\  /  | |          /=^=^=^=^=\ ',0ah,0dh
dw '     \_____|\_____|     \/  \/   |_|          :^= HAPPY =^; ',0ah,0dh
dw '                                             |^ EASTER! ^|',0ah,0dh
dw '                                              :^=^=^=^=^=^:',0ah,0dh
dw '                                              \=^=^=^=^=/',0ah,0dh
dw '                                               `.=^=^=.`',0ah,0dh
dw '                                                 `~~~` ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh                                      
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '           \(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/\(^o^)/',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh

dw '$',0ah,0dh

  
   Give_up_str dw '  ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh       
dw '                                              ',0ah,0dh       
dw '                                              ',0ah,0dh
dw '             (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-) (-_-)',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh                                      
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh
dw '                                              ',0ah,0dh

dw '$',0ah,0dh
       
       
        
       theEnd:
       
       DEFINE_CLEAR_SCREEN
       DEFINE_PRINT_NUM 
       DEFINE_PRINT_NUM_UNS 
       
       END