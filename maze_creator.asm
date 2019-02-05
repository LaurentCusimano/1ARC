org 100h

include emu8086.inc 
          
 
 
   draw_maze_contour:
        mov dl,1
        mov dh,0
        draw_topmaze:
        
            add dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;key:       
            PRINT 'II' 
            cmp dl,60
            je draw_downmaze
            loop draw_topmaze
    
        draw_downmaze:
            add dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;key:       
            PRINT 'II' 
            cmp dh,22
            je draw_bottommaze
           loop draw_downmaze
        
        draw_bottommaze:
            sub dl,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;key:       
            PRINT 'II' 
            cmp dl,2
            je draw_upmaze
           loop draw_bottommaze 
        
        draw_upmaze:
            sub dh,1
            ;setcursor:
            mov ah, 02h
            mov bh, 00
            int 10h
            ;key:       
            PRINT 'II' 
            cmp dh,0
            je testos
           loop draw_upmaze 
           
           
           
 
 
     testos:
     
 
 
 
          
          
          
;object(1stkey RED) spawn draw 
    draw_redkey:
        mov dl,2
        mov dh,6
        ;setcursor:
        mov ah, 02h
        mov bh, 00
        int 10h
        ;key:       
    PRINT 216
    
    draw_reddoor:
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
    
    
    
    ret 
    
    END          