         
   
        
    
 
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
            je intro
           loop draw_upmaze 
           
           
           
 
 
     Intro:
        mov dl,30
        mov dh,11
        mov ah, 02h
        mov bh, 00
        int 10h       
        PRINT 'MazeGame'
        mov dl,25
        mov dh,11
        mov ah, 02h
        mov bh, 00
        int 10h
        PRINT '             '
        
        
     
     
     draw_redzone:
        mov dl,14
        mov dh,22;en realiter 21 mais 22 pour afficher le premier mur
        
        
        draw_redwall1:
            sub dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
            cmp dh, 16
            je draw_redwall2  
            
            loop draw_redwall1 
            
         draw_redwall2:
            add dl,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
            cmp dl, 26
            je draw_redwall3  
            
            loop draw_redwall2
            
         draw_redwall3:
            add dh,1
            mov ah, 02h
            mov bh, 00
            int 10h       
            PRINT 'I'
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
                mov dl,25
                mov dh,20
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;key:       
                PRINT 216
    
            draw_reddoor:
                ;object(door) spawn draw 
    
                mov dl,26
                mov dh,17
                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
                ;door:       
                PRINT 177



            draw_hero:
            

                mov dl, 15 ; column
                mov dh, 21 ; row 

                ;setcursor:
                mov ah, 02h
                mov bh, 00
                int 10h
        
                PRINT ':)'
    
    
   
              jmp init_var
    
   
    
    
     
                  