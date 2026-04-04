*-----------------------------------------------------------
* Title      : Lights Off - An Assembly Game
* Written by : Kevin Michael (c00313509)
* Description: Recreating the Lights Out game that can be found at
*              https://dotnet.github.io/dotnet-console-games/Lights%20Out
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    ; D7 being 1 is the condition for the while loop to run
    MOVE.B  #1, D7
    
    ; The index of grid that player is on (set to 0 at start)
    MOVE.B  #8, D6
    
    ; Start the loop if condition satisfies
    CMPI.B  #1, D7
    BEQ     WHILE_LOOP


WHILE_LOOP:
    ; Is loop condition true?
    TST.B   D7
    BEQ     ENDOFPROG
    
    ; Sub-Routine to Display on screen
    BSR     DISPLAY
    
    ; Sub-Routine to Update Game
    BSR     UPDATE
    
    
    ; Run it again
    BRA     WHILE_LOOP
    
    
F_FLIP:
    ; D0 will have quotient (row) and D1 will have remainder (col)
    MOVE.L  D6, D0
    DIVU    #5, D0
    MOVE.L  D0, D1
    SWAP    D1
    
    LEA     ROW_0, A2
    ADD.W    D6, A2
    ; fLIP THE CURRENT ONE
    BCHG    #0,(A2)
    
    CMPI.B  #0, D1
    BNE     FLIP_WEST
    
    THREE_FLIP_LEFT:
    
    CMPI.B  #0, D0
    BNE     FLIP_NORTH
    
    TWO_FLIP_LEFT:
    
    CMPI.B  #4, D1
    BNE     FLIP_EAST
    
    ONE_FLIP_LEFT:
    
    CMPI.B  #4, D0
    BNE     FLIP_SOUTH
    
    NO_FLIP_LEFT:


    BRA     WHILE_LOOP
    
    
    
FLIP_WEST:
    LEA     ROW_0, A2
    ADD.W   D6, A2
    SUB.W   #1, A2
    BCHG    #0, (A2)

    BRA THREE_FLIP_LEFT
    
FLIP_NORTH:
    LEA     ROW_0, A2
    ADD.W   D6, A2
    SUB.W   #5, A2
    BCHG    #0, (A2)
    
    BRA TWO_FLIP_LEFT
    
FLIP_EAST:
    LEA     ROW_0, A2
    ADD.W   D6, A2
    ADD.W   #1, A2
    BCHG    #0, (A2)
    
    BRA ONE_FLIP_LEFT
    
FLIP_SOUTH:
    LEA     ROW_0, A2
    ADD.W   D6, A2
    ADD.W   #5, A2
    BCHG    #0, (A2)
    
    BRA NO_FLIP_LEFT
    

F_WEST:

    MOVE.L  D6, D2
    DIVU    #5, D2
    ; Masking Quotient of division coz we only need Remainder
    AND.W   #$0000, D2
    
    ; currentPos is leftmost if remainder == 0
    CMPI.L  #0, D2
    
    ; If currentPos not in leftmost, then move left
    BNE     MOVE_WEST
    
    BRA     WHILE_LOOP
    
MOVE_WEST:
    SUBI.B   #1, D6
    BRA     WHILE_LOOP
   
F_NORTH:
    MOVE.L  D6, D2
    
    DIVU    #5, D2
    
    ; currentPos is topmost if quotient == 0
    CMPI.B  #0, D2
    
    ; If currentPos not in topmost, then move up
    BNE     MOVE_NORTH
    
    BRA     WHILE_LOOP
    
MOVE_NORTH:
    SUBI.B   #5, D6
    BRA     WHILE_LOOP
    
F_EAST:

    MOVE.L  D6, D2
    DIVU    #5, D2
    ; Masking Quotient of division coz we only need Remainder
    AND.W   #$0000, D2
    
    ; currentPos is leftmost if remainder == 4 (grid ranges from 0-4)
    ; If remainder == 4, then  the only bit active (after masking) would be the 18th  bit.
    ; This we can test using BTST
    BTST    #18, D2
    
    ; If currentPos not in rightmost, then move right
    BEQ     MOVE_EAST
    
    BRA     WHILE_LOOP
    
MOVE_EAST:
    ADD.B   #1, D6
    BRA     WHILE_LOOP
    
F_SOUTH:
    MOVE.L  D6, D2
    DIVU    #5, D2
    ; currentPos is bottommost if quotient == 4
    CMPI.B  #4, D2
    
    ; If currentPos not in bottommost, then move down
    BNE     MOVE_SOUTH
    
    BRA     WHILE_LOOP
    
MOVE_SOUTH:
    ADD.B   #5, D6
    BRA     WHILE_LOOP
    
    
DISPLAY:
    ; Do all displays
    
    ;Clear Screen before next draw
    MOVE.W  #$FF00, D1
    MOVE.B  #11, D0
    TRAP    #15
       
    
    BSR DISPLAY_INPUT
    
    BSR DISPLAY_GRID
    
    
    RTS


DISPLAY_INPUT:
    ; Display messages for input
    LEA     INPUT_MESSAGE_1, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    LEA     INPUT_MESSAGE_2, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    LEA     INPUT_MESSAGE_3, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    LEA     INPUT_MESSAGE_4, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    LEA     INPUT_MESSAGE_5, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    LEA     CARRIAGE_RETURN, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    RTS
    
    
    
DISPLAY_GRID:
    
    ; initialize variables for nested for loop
    MOVE.B  #0, D3  ; ROW
    MOVE.B  #0, D4  ; COL
     
     
    OUTER_LOOP:
        CMPI.B  #4, D3
        BGT     OUTER_LOOP_END
        
        FIRST_INNER_LOOP:
        CMPI.B  #4, D4
        BGT     FIRST_INNER_LOOP_END
        
        CMPI.B  #0, D3
        BEQ     LOAD_ROW_0
        
        CMPI.B  #1, D3
        BEQ     LOAD_ROW_1
        
        CMPI.B  #2, D3
        BEQ     LOAD_ROW_2
        
        CMPI.B  #3, D3
        BEQ     LOAD_ROW_3
        
        CMPI.B  #4, D3
        BEQ     LOAD_ROW_4
        
        
        RETURN_AFTER_LOADING_ROW:
        
        MOVE.B  #1,D2
        CLR.L   D1
        
        CMPI.B  #0, D4
        BEQ     LOAD_COL_0
        
        CMPI.B  #1, D4
        BEQ     LOAD_COL_1
        
        CMPI.B  #2, D4
        BEQ     LOAD_COL_2
        
        CMPI.B  #3, D4
        BEQ     LOAD_COL_3
        
        CMPI.B  #4, D4
        BEQ     LOAD_COL_4
        
        RETURN_AFTER_LOADING_COL:
        
        MOVE.B  (A2), D1
        MOVE.B  #20, D0
        TRAP    #15
        
        LEA     SPACE, A1
        MOVE.B  #14, D0
        TRAP    #15
        
        
        ADDI.B  #1, D4
        BRA     FIRST_INNER_LOOP
        
        FIRST_INNER_LOOP_END:
        MOVE.B  #0, D4
        
        
        
        LEA     CARRIAGE_RETURN, A1
        MOVE.B  #13, D0
        TRAP    #15
        
        
        SECOND_INNER_LOOP:
        CMPI.B  #4, D4
        BGT     SECOND_INNER_LOOP_END
        
        
        ; D0 will be row * 5 + col
        MOVE.B  #5, D0
        MULU    D3, D0
        ADD.B   D4, D0
        
        CMP.B   D0, D6
        BEQ     PRINT_UNDERSCORE
        BNE     PRINT_SPACE

        
        CONTINUE_SECOND_INNER_LOOP:      
        
        ADDI.B  #1, D4
        BRA     SECOND_INNER_LOOP
        
        SECOND_INNER_LOOP_END:

        
        LEA     CARRIAGE_RETURN, A1
        MOVE.B  #13, D0
        TRAP    #15
        
        
        CLR.B   D4
        ADDI.B  #1, D3
        BRA     OUTER_LOOP
        
    OUTER_LOOP_END:
        RTS
  
  
PRINT_UNDERSCORE:
    LEA     UNDERSCORE, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    LEA     SPACE, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    BRA     CONTINUE_SECOND_INNER_LOOP
    
PRINT_SPACE:
    LEA     SPACE, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    LEA     SPACE, A1
    MOVE.B  #14, D0
    TRAP    #15
    
    BRA     CONTINUE_SECOND_INNER_LOOP
  
  
  
LOAD_COL_0:
    LEA     (A2),A2
    BRA     RETURN_AFTER_LOADING_COL
LOAD_COL_1:
    LEA     1(A2),A2
    BRA     RETURN_AFTER_LOADING_COL
LOAD_COL_2:
    LEA     2(A2),A2
    BRA     RETURN_AFTER_LOADING_COL
LOAD_COL_3:
    LEA     3(A2),A2
    BRA     RETURN_AFTER_LOADING_COL
LOAD_COL_4:
    LEA     4(A2),A2
    BRA     RETURN_AFTER_LOADING_COL
    
LOAD_ROW_0:
    LEA     ROW_0, A2
    BRA     RETURN_AFTER_LOADING_ROW
LOAD_ROW_1:
    LEA     ROW_1, A2
    BRA     RETURN_AFTER_LOADING_ROW
LOAD_ROW_2:
    LEA     ROW_2, A2
    BRA     RETURN_AFTER_LOADING_ROW
LOAD_ROW_3:
    LEA     ROW_3, A2
    BRA     RETURN_AFTER_LOADING_ROW
LOAD_ROW_4:
    LEA     ROW_4, A2
    BRA     RETURN_AFTER_LOADING_ROW
    
    
UPDATE:
    ; Input number into D1
    MOVE.B  #4, D0
    TRAP    #15
    
    
    ; Is inputted number 4?
    CMPI.B  #4,D1
    BEQ     F_WEST
    
    ; Is inputted number 8?
    CMPI.B  #8,D1
    BEQ     F_NORTH
    
    ; Is inputted number 6?
    CMPI.B  #6,D1
    BEQ     F_EAST
    
    ; Is inputted number 2?
    CMPI.B  #2,D1
    BEQ     F_SOUTH
    
    CMPI.B  #5, D1
    BEQ     F_FLIP
    
    
    RTS 
    

    ORG $8000
INPUT_MESSAGE_1   DC.B    '4 to go West ',0
INPUT_MESSAGE_2   DC.B    '8 to go North',0
INPUT_MESSAGE_3   DC.B    '6 to go East',0
INPUT_MESSAGE_4   DC.B    '2 to go South',0
INPUT_MESSAGE_5   DC.B    '5 to flip switches',0


; Is this better than printing CR and LF seperately using Task 6?
; Prolly not but have to testt clock cycles to confirm.
CARRIAGE_RETURN DC.B    '',0
SPACE           DC.B    ' ',0
UNDERSCORE      DC.B    '_',0


    ORG $7000
; Creating a grid of 25 bytes with values set to 0
ROW_0 DC.B 0,0,0,0,0
ROW_1 DC.B 0,0,0,0,0
ROW_2 DC.B 1,0,1,0,1
ROW_3 DC.B 0,0,0,0,0
ROW_4 DC.B 0,0,0,0,0 




    SIMHALT             ; halt simulator

* Put variables and constants here
ENDOFPROG:
    END    START        ; last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
