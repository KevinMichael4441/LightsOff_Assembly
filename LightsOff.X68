*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    ; Display "Enter an input: "
    LEA     MESSAGE, A1
    MOVE.B  #13, D0
    TRAP    #15
    
    ; Input number into D1
    MOVE.B  #4, D0
    TRAP    #15
    
    
    ; Is inputted number 1?
    CMPI.B  #1,D1
    BEQ     F_ONE
    
    ; Is inputted number 2?
    CMPI.B  #2,D1
    BEQ     F_TWO
    
    ; End the Program
    BRA     ENDOFPROG
    
    
F_ONE:
    LEA     M_ONE, A1
    MOVE.B  #13, D0
    TRAP    #15
    RTS
   
F_TWO:
    LEA     M_TWO, A1
    MOVE.B  #13, D0
    TRAP    #15
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
