org 100h

include emu8086.inc 
          
 
          
   
        
    
    
    ;jmp draw_rules
   draw_maze_contour:
        mov dl,1
        mov dh,0
        draw_topleft_coner:
        ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 201
        
        draw_topmaze:
        
            add dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 205 
            cmp dl,60
            je draw_topright_coner
            loop draw_topmaze
        
        draw_topright_coner:
            add dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h                   
            PRINT 187
        
    
        draw_downmaze:
            add dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 186 
            cmp dh,21
            je draw_bottomright_coner
           loop draw_downmaze
           
        draw_bottomright_coner:
            ;setcursor:
            add dh,1
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 188
        
        draw_bottommaze:
            sub dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 205 
            cmp dl,2
            je draw_bottomleft_coner
           loop draw_bottommaze
           
         draw_bottomleft_coner:
            ;setcursor:
            sub dl,1
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 200 
        
        draw_upmaze:
            sub dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 186 
            cmp dh,1
            je draw_inv
           loop draw_upmaze 
           
           
          
        
     jmp draw_redzone
      draw_inv:
        mov dl,63
        mov dh,-1
        draw_leftinv:
        
            add dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dh,5
            je draw_downinv
            loop draw_leftinv
    
        draw_downinv:
            add dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT '-' 
            cmp dl,75
            je draw_rightinv
           loop draw_downinv
        
        draw_rightinv:
            sub dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dh,0
            je draw_textinv
           loop draw_rightinv
           
          draw_textinv:
                mov dl,65
                mov dh,2
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 'Inventory'
            
           
          
                
                
                
                
     draw_redzone:
     
     draw_wall1_redzone:
     
           mov dl,4
           mov dh,22
           call SetCursor
           PRINT 202
           
           draw_wall1_redzone_p2:
           
          sub dh,1
          call SetCursor
          PRINT 186
          
          cmp dh,19
          je draw_wall1_redzone_p3
          loop draw_wall1_redzone_p2 
            
          draw_wall1_redzone_p3:
          
          PRINT 201
          
          add dl,1
          call SetCursor
          PRINT 205
           
        
     
          jmp draw_hero
        
     draw_object_redzone:
        ;object(1stkey RED) spawn draw 
            draw_redkey:
            ;cursor pos:
            mov dl,25 
            mov dh,20
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

             
    
            draw_reddoor:
                ;object(door) spawn draw 
                ;cursor pos:
                mov dl,26 
                mov dh,17
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
                PRINT 177

       draw_object_bluezone:
   
            draw_bluedoor:
                ;object(door) spawn draw 
                ;cursor pos:
                mov dl,30 
                mov dh,17
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
                PRINT 177
             
                                       
          draw_hero:
            

              mov dl, 2 ; column
              mov dh, 21 ; row 

              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
        
              PRINT ':)'
    
    
   
          draw_rules:
          
            mov dl,63
            mov dh,18
            ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              
              PRINT ':) -> YOU'
            
            
            
              add dh,1
              add dl,1
              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              
              PRINT 216
              
              add dl,2
              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              
              PRINT '-> A KEY'
            
            
              add dh,1
              sub dl,2
              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              
              PRINT 177
              
              add dl,2
              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              
              PRINT '-> A DOOR'
            
            
            add dh,1
            sub dl,3
            ;setcursor:
             mov ah, 02h
             mov bh, 00
             int 10h
             PRINT 'REDkey open'
            
            add dh,1
            ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
            PRINT 'REDdoor'
            
            add dh,1 
            ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
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
                
             add dl,2
             ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
              PRINT '---->'
              
              add dl,6
             
            
            ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
                mov cx, 1 ; nb char
                mov bh, 0
                mov bl, 0x40 ; color
                mov al, 0x20 ; blank char
                mov ah, 0x9
                int 0x10 
                mov ah, 02h
                mov bh, 00
                int 10h 
                PRINT 177
              
             
              
              
     SetCursor proc near
     mov ah, 02h
     mov bh, 00
     int 10h
     ret
     SetCursor endp        
    
    
    
    ret 
                  