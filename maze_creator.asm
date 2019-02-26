org 100h

include emu8086.inc 
          
 
          
   
        
    
    jmp draw_inv
   draw_maze_contour:
        mov dl,1
        mov dh,0
        draw_topmaze:
        
            add dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dl,60
            je draw_downmaze
            loop draw_topmaze
    
        draw_downmaze:
            add dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dh,22
            je draw_bottommaze
           loop draw_downmaze
        
        draw_bottommaze:
            sub dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dl,2
            je draw_upmaze
           loop draw_bottommaze 
        
        draw_upmaze:
            sub dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;wall:       
            PRINT 'I' 
            cmp dh,0
            je draw_redzone
           loop draw_upmaze 
           
           
        
        
     
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
            
           
          draw_keyinv:
            
                mov dl,65
                mov dh,4
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
                
                add dl,2
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
                
                add dl,2
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
                
                add dl,2
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
                
                add dl,2
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
                
                
                
                
                
                
     draw_redzone:
        mov dl,14
        mov dh,22;en realiter 21 mais 22 pour afficher le premier mur
        
        
        draw_redwall1:
            sub dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 186
            cmp dh, 16
            je draw_redwall2  
            
            loop draw_redwall1 
            
         draw_redwall2:
            add dl,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 205
            cmp dl, 26
            je draw_redwall3  
            
            loop draw_redwall2
            
         draw_redwall3:
            add dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 186
            cmp dh, 21
            je cursor_internalredwall1  
            
            loop draw_redwall3
            
         cursor_internalredwall1: 
         ;mise en place du curseur
         mov dl,17
         mov dh,22
         mov ah, 02h
         mov bh, 00
         int 10h
           
            
         draw_internalredwall1:
            
            
            sub dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
            cmp dh, 19
            je cursor_internalredwall2  
            
            loop draw_internalredwall1
            
         cursor_internalredwall2:   
            ;mise en place du curseur   
            mov dl,21
            mov dh,16
            mov ah, 02h
            mov bh, 00
            int 10h
             
            
         draw_internalredwall2:
            
            
            add dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
            cmp dh, 20
            je cursor_internalredwall3  
            
            loop draw_internalredwall2
            
         cursor_internalredwall3:   
            ;mise en place du curseur   
            mov dl,26
            mov dh,19
            mov ah, 02h
            mov bh, 00
            int 10h 
            
         draw_internalredwall3:
            
            
            sub dl,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
            cmp dl, 24
            je draw_object_redzone  
            
            loop draw_internalredwall3
         
        
     
     
     
        
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
            

              mov dl, 15 ; column
              mov dh, 21 ; row 

              ;setcursor:
              mov ah, 02h
              mov bh, 00
              int 10h
        
              PRINT ':)'
    
    
   
         
   
    
    
     
                    
    
    
    
    
    
    ret 
                  