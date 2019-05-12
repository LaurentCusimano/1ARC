name "MazeGame"

org 100h

include emu8086.inc 


  CURSOROFF;Hide the cursor (works with "emu8086.inc")   
Menu:
 
   call CLEAR_SCREEN
      ;Display menu
      call set_background_color
      mov ah,09h
      mov dh,0
      mov dx, offset game_menu_str
      int 21h


  
wait_keypress:
    ;wait for a key to be pressed:
    mov ah, 0h
    int 16h                                              
    
    
    cmp al, 13 ;if "enter":
    je start_maze_game 

    
    cmp al, 27 ;if "esc":
    je give_up
     
    jmp wait_keypress



start_maze_game: 

    call CLEAR_SCREEN
    call set_background_color
    ;draw the maze in 2 step:
    include "maze_part1.asm" 
     maze_part2:
     
     include "maze_part2.asm" 
   
   
          
init_var:
    ColliderDetected DB 'n';switched to 'y' if a collision is detected
    
    IsGreen DB 'n';switched to 'y' if the green key is collected
    
        
    EE_eggs Dw 0 ;number of egg picked up
   
    Event_key Dw 1 ;avoid key event duplication
    whichKey Dw 0;door opening variable / if player has the right key 
    MovesCount Dw 0;stores how many moves that you make before finishing the maze
    
    ;stores the player's last position
    DhPlayer Db 1
    DlPlayer Db 1
    
    mov dl, 2 ; column
    mov dh, 21 ; row
    
    
    jmp inside_loop

main: 
  
      
    
     
       
    
    inside_loop:
    ;set ColliderDetected to its default state:
    mov ColliderDetected,'n' 
    
     ;wait for a key to be pressed:
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
    cmp al, 27 ;if "esc":
    je give_up
    
    jmp main
            
 

    Right:
        add dl, 2
        call SetCursor
        call TestColid
        sub dl,2
        call SetCursor
        ;test if a collision is detected:
        cmp ColliderDetected,'y'
        je main
        ;if not move the player to his new location:
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
      sub dl, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      ;moves the rotates player's head: 
      PRINT '(:' 
      ;test if a collision is detected:
      cmp ColliderDetected,'y'
      je main
      ;if not move the player to his new location:
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
      sub dh, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      call TestColid
      sub dl,1      
      add dh,1
      call SetCursor
      ;test if a collision is detected:
      cmp ColliderDetected,'y'
      je main
      ;if not move the player to his new location:
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
      add dh, 1
      call SetCursor
      call TestColid
      add dl,1
      call SetCursor
      call TestColid
      sub dl,1  
      sub dh,1
      call SetCursor
      ;test if a collision is detected:
      cmp ColliderDetected,'y'
      je main
      ;if not move the player to his new location:
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
   ;update the cursor position:
       mov ah, 02h
       mov bh, 00
       int 10h
       ret
   TestColid:
   ;tests if next character is a "blacklist" one:
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
       ;horizontal wall
       cmp al,205 
       je CollidYes
       
       ;vertical wall
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
          
            ;message to let you know you collected an object:  
            PRINT 'You found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT 'an egg :D'
             
            
            call Load_PlayerLoc
      
      
      ;check if all the eggs have been picked up:
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
          
            ;Display dialog from the EE_guy :   
            PRINT 'Hello can u';lack of spelling voluntary:
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT 'Find my eggs?:P'
             
            include "EE.asm"
            call Load_PlayerLoc
            ret
     
   
    keytest:
    ;checks what key we have:
            nokeytest:;look at first if you have a key
            cmp whichKey,0
            je display_nokeymessage
            jmp redkeytest   
          
           ;test all key value:
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
                    ;verify if the boolean "IsGreen" is true:
                    cmp IsGreen,'y'
                    je opendoor5
                    
                    
                    
                    
                    jmp display_nokeymessage
                    havenokey:
                    ret
   
   
   
   
   objectpickup:
   ;look at what key we have picked up:
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
          
            ;message to let you know you collected an object:  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a redkey'
             
            ;store this information in a variable:
            mov whichKey,1
            call UpdateInv ;to update the inventory:
            ;return the cursor to its original position:
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
          
            ;message to let you know you collected an object:  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a pinkkey' 
            ;store this information in a variable:
            mov whichKey,2
            call UpdateInv ;to update the inventory:
            ;return the cursor to its original position:
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
          
            ;message to let you know you collected an object:  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a bluekey' 
            ;store this information in a variable:
            mov whichKey,3
            call UpdateInv  ;to update the inventory:
            ;return the cursor to its original position:
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
          
            ;message to let you know you collected an object:  
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a Orangekey' 
            ;store this information in a variable:
            mov whichKey,4
            call UpdateInv  ;to update the inventory:
            ;return the cursor to its original position:
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
          
            ;message to let you know you collected an object: 
            PRINT 'You have found'
            mov dl,62
            mov dh,7
            call SetCursor
          
            PRINT ' a Greenkey' 
            ;store this information in a variable:
            mov whichKey,5
            mov IsGreen,'y';indicates that the green key has been picked up
            call UpdateInv ;to update the inventory:
           ;return the cursor to its original position:
            call Load_PlayerLoc
            call SetCursor 
            mov Event_key,6
            ret
                    
        display_nokeymessage:
        
;prevents the opening of the door if the player does not have the right key:
            call CollidYes
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
          
          
            ;return the cursor to its original position:
            call Load_PlayerLoc                                        
            mov ah, 02h
            call SetCursor
            
            ret
                  
   opendoor1:
          call Save_PlayerLoc
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
            
          ;return the cursor to its original position:
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
          ;return the cursor to its original position:
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
          ;return the cursor to its original position:
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
                
           draw_fixwall:
                mov dl,52
                mov dh,19
                mov bh, 0
                mov ah, 0x2
                int 0x10
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x19 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h       
                PRINT 186
                
                
                
          ;return the cursor to its original position:
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
         
                    
          ;when the last door is opened , you win:
          jmp win
          
          
  
  
  
   give_up:
   ;display loss screen:
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
   ;display win screen:
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
        
        
        
        PRINT 'press any key to quit the game'
        
        
                            
            
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
    
    

            jmp theEnd

           
    win_EE:
    ;display easter egg winning screen: 
    
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
        
        PRINT 'You found all the eggs :D awesome!'
        ADD dh ,1
        sub dl,8
        mov ah, 02h
        mov bh, 00
        int 10h
        
        
        
        PRINT 'Press any key to quit the game'
        
        
                            
            
         mov dl,26
         mov dh,15
         call SetCursor
         
         PRINT 'you move '
        MOV ax,MovesCount
  

       
            call PRINT_NUM   
            
             PRINT 'times'
            
            
            ;wait for a key to be pressed:
            mov ah, 0h
            int 16h                                              
    
    

            jmp theEnd                                               
        
   
    
   
   clear_oldmessage proc near
    ;delete the old dialog:
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
     ;save player position:
     mov DhPlayer,dh
     mov DlPlayer,dl
       
        ret
       
               
    Save_PlayerLoc endp 
   
   Load_PlayerLoc proc near
    ;change cursor position to the last saved player position:
     mov dh,DhPlayer
     mov dl,DlPlayer
       
        ret
       
               
    Load_PlayerLoc endp 
   
   
   UpdateInv proc near
    ;update the inventory:
     testhavekey1:
             cmp whichKey,1
             je Draw_on_key1
             jmp testhavekey2
             Draw_on_key1:
             ;draw in inventory which key we have unlocked:
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
             ;draw in inventory which key we have unlocked:
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
             ;draw in inventory which key we have unlocked:
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
             ;draw in inventory which key we have unlocked:
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
             ;draw in inventory which key we have unlocked:
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
    ;delete last player position: 
            
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
    mov cx, 2024 ; print 2024 chars (all the screen)
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
dw '            | ^ Press "enter" to play ^ || ^   Press "esc" to quit ^ | ',0ah,0dh
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