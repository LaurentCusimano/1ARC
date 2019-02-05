org 100h

include emu8086.inc 



start_maze_game:
    call CLEAR_SCREEN 
    ;init var:
    mov sp,1 ;eviter duplication d'evenement key
    mov bp,0 ;variable d'ouverture de porte / si la bonne key
    mov si,0 ;eviter duplication d'evenement door 

    ;object(1stkey) spawn draw 
    
    mov dl,2
    mov dh,6
    ;setcursor:
    mov ah, 02h
    mov bh, 00
    int 10h
    ;key:       
    PRINT 216
    
    draw_door1:
        ;object(door) spawn draw 
    
        mov dl,16
        mov dh,6
        ;setcursor:
        mov ah, 02h
        mov bh, 00
        int 10h
        ;door:       
        PRINT 177



    ;hero spawn draw

    mov dl, 6 ; column
    mov dh, 6 ; row 

    ;setcursor:
    mov ah, 02h
    mov bh, 00
    int 10h

    PRINT ':)'

    jmp inside_loop

main:
    

    testpos: 
        ;test de position pour l'obtention des objets / ouverture des portes 
        ;besoin de faire un "and" pour verifier la ligne ET la collonne (cette fonction n'est pas complete...
        ;verifie pos pour key1
        cmp dl,2
        je objectpickup 
        
        ;verifie pos pour porte 1
        cmp dl,14 
        je haskey
        
       
    
    inside_loop:
   

        
        redrawthings:
        ;certain object peuvent etre effacer accidentellement par le joueur il seront alors lister ici et redessinner
        ;principalement des portes/desmur
        
           
            
            
        
    
    
    
    
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
        ;move player to his new location
        add dl, 2
        call SetCursor
        PRINT ':)'
        jmp main
        ret

    Left:
      call clear_player
      ;move player to his new location
      sub dl, 2
      call SetCursor
      PRINT '(:'
      jmp main
      ret

   Up:
     call clear_player
     ;move player to his new location
     sub dh, 2
     call SetCursor
     PRINT ':)'
     jmp main
     ret

   Down:
      call clear_player
      ;move player to his new location
      add dh, 2
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
            mov dl,20
            mov dh,20
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
          
            ;message pour prevenir de l'obtention de l'objet  
            PRINT 'maxon a pecho une clef' 
            ;stock cette info dans une variable:
            mov bp,1
            ;met a jour "si" pour pouvoir ressayer d'ouvrir la porte associer:
            mov si,0
            ;remet le cursor a sa position d'origine:
            mov dl,2
            mov dh,6
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
          
            mov dl,20
            mov dh,20
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h 
          
            PRINT 'maxon na pas de clef'
          
          
            ;remet le cursor a sa position d'origine:
            mov dl,14 ;pas la position d'origine pour eviter d'effacer la porte:
            mov dh,6
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            jmp inside_loop      
   opendoor:
          call clear_oldmessage
          
          mov dl,20
          mov dh,20
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h 
          
          PRINT 'maxon open door'
          
          ;avance "si":
          mov si,2
          ;remet le cursor a sa position d'origine:
          mov dl,14  ;pas la position d'origine pour eviter d'effacer la porte:
          mov dh,6
          ;setcursor:
          mov ah, 02h
          mov bh, 00
          int 10h
          jmp inside_loop
    
  
  
  
  
  
   clear_oldmessage proc near
        mov dl,20
        mov dh,20 
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT '                                '
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
       
       DEFINE_CLEAR_SCREEN 
       END