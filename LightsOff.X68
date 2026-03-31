*-----------------------------------------------------------
* Title      : Lights Off - An Assembly Game
* Written by : Kevin Michael (c00313509)
* Description: Recreating the Lights Out game that can be found at
*              https://dotnet.github.io/dotnet-console-games/Lights%20Out
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    ; D8 being 1 is the condition for the while loop to run
    MOVE.B  #1, D7
    
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
    
    
F_ONE:
    LEA     M_ONE, A1
    MOVE.B  #13, D0
    TRAP    #15
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
    ; Display "Enter an input: "
    LEA     MESSAGE, A1
    MOVE.B  #13, D0
    TRAP    #15
    RTS
    
    
UPDATE:
    ; Input number into D1
    MOVE.B  #4, D0
    TRAP    #15
    
    
    ; Is inputted number 1?
    CMPI.B  #1,D1
    BEQ     F_ONE
    
    ; Is inputted number 2?
    CMPI.B  #2,D1
    BEQ     F_TWO
    
    ; Is inputted number 2?
    CMPI.B  #3,D1
    BEQ     F_THREE
    
    RTS 
    

    ORG $8000
MESSAGE DC.B    'Enter an input: ',0
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
