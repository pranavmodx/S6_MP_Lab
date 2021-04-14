ASSUME DS:DATA,CS:CODE

DATA SEGMENT
PROMPT1 DB 0AH,0DH,"First Number:$"
PROMPT2 DB 0AH,0DH,"Second Number:$"
PROMPT3 DB 0AH,0DH,"Product is:$"
DATA ENDS

CODE    SEGMENT
START:  MOV AX,DATA
    	MOV DS,AX

        LEA DX,PROMPT1
	MOV AH,09H
	INT 21H

; input using stack method
; obtains actual no. in register instead of ascii code for it
        MOV BX,0
INPUT_NUM1:     
        MOV AH,01H
        INT 21H
        CMP AL,0DH ; enter key function code; carriage return
        JZ NEXT_NUM ; jump only if 0 (in this case, when enter is pressed)
        MOV AH,0 ; clear AH
        SUB AL,30H ; individual digit (actual - decimal) of no.
        PUSH AX ; push digit of the no. to stack
        
; obtaining full no. (in decimal) from individual digits pushed onto stack 
        MOV AX,10D ; D -> decimal
        MUL BX ; multiply BX (having 0 or prev digit) with AX and store in AX
        POP BX ; get new digit
        ADD BX,AX ; add new digit with (old digit * 10)
        JMP INPUT_NUM1

NEXT_NUM:  PUSH BX ; BX has the 1st no. ; it is pushed to stack
        LEA DX,PROMPT2 ; similar process for 2nd no.
	MOV AH,09H
	INT 21H


        MOV BX,0
INPUT_NUM2: MOV AH,01H
        INT 21H
        CMP AL,0DH
        JZ MUL_OPERATION
        MOV AH,0
        SUB AL,30H
        PUSH AX

        MOV AX,10D
        MUL BX
        POP BX
        ADD BX,AX
        JMP INPUT_NUM2

; at this stage, 1st no is present in stack and 2nd no. is in BX

MUL_OPERATION:  
        POP AX
        MUL BX ; actual multiplication happens here ; multiply BX with AX and store in AX
        PUSH AX ; push result onto stack to retrieve later safely, before mutating AX

        LEA DX,PROMPT3
        MOV AH,09H
        INT 21H
        POP AX
        MOV CX,0
        MOV DX,0
        MOV BX,10D

SPLIT_DIGITS:
        DIV BX
        PUSH DX ; AX stores quotient, DX stores remainder ; we need remainder (last digit)
        MOV DX,0
        INC CX 
        ; counter for keeping track of no. of digits in result 
        ; to pop from stack accordingly
        OR AX,AX ; till AX is zero ; alternatively we can use CMP AX, 0H
        JNZ SPLIT_DIGITS

PRINT_RESULT:  POP DX
        ADD DL,30H
        MOV AH,02H
        INT 21H
        LOOP PRINT_RESULT ; checks whether CX = 0 else decrements it by 1

        MOV AH,4CH ; exit
        INT 21H

CODE ENDS 
END START