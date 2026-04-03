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
    
    
F_WEST:

    MOVE.L  D6, D3
    
    DIVU    #5, D3
    ; Masking Quotient of division coz we only need Remainder
    AND.W   #$0000, D3
    
    ; currentPos is leftmost if remainder == 0
    CMPI.L  #0, D3
    
    ; If currentPos not in leftmost, then move left
    BNE     MOVE_WEST
    
    BRA     WHILE_LOOP
    
MOVE_WEST:
    SUB.B   #1, D6
    BRA     WHILE_LOOP
   
F_TWO:
    LEA     M_TWO, A1
    MOVE.B  #13, D0
    TRAP    #15
    BRA     WHILE_LOOP
    
F_THREE:
    BCLR    #0, D7
    BRA     WHILE_LOOP
    
    
DISPLAY:
    ; Do all displays
    
    ;Clear Screen before next draw
    MOVE.W  #$FF00, D1
    MOVE.B  #11, D0
    TRAP    #15
       
    
    BSR DISPLAY_INPUT
    
    
    MOVE.L  D6, D1
    MOVE.B  #3, D0
    TRAP    #15
    
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
    
    
UPDATE:
    ; Input number into D1
    MOVE.B  #4, D0
    TRAP    #15
    
    
    ; Is inputted number 4?
    CMPI.B  #4,D1
    BEQ     F_WEST
    
    ; Is inputted number 2?
    CMPI.B  #2,D1
    BEQ     F_TWO
    
    ; Is inputted number 2?
    CMPI.B  #3,D1
    BEQ     F_THREE
    
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



M_ONE   DC.B    'U entered ONE!',0
M_TWO   DC.B    'U entered TWO!',0

    SIMHALT             ; halt simulator

* Put variables and constants here
ENDOFPROG:
    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
