ASSUME DS:DATA,CS:CODE

DATA SEGMENT
PROMPT1 DB 0AH,0DH,"First Number:$"
PROMPT2 DB 0AH,0DH,"Second Number:$"
QUOTIENT DB 0AH,0DH,"Quotient is:$"
REMAINDER DB 0AH,0DH,"Remainder is:$"
DATA ENDS

CODE    SEGMENT
START:  MOV AX,DATA
    	MOV DS,AX

        LEA DX,PROMPT1
	MOV AH,09H
	INT 21H

        MOV BX,0

INPUT_NUM1: MOV AH,01H
        INT 21H
        CMP AL,0DH
        JZ NEXT_NUM
        MOV AH,0
        SUB AL,30H
        PUSH AX

        MOV AX,10D
        MUL BX
        POP BX
        ADD BX,AX
        JMP INPUT_NUM1

NEXT_NUM:   
        PUSH BX
        LEA DX,PROMPT2
	MOV AH,09H
	INT 21H
        MOV BX,0

INPUT_NUM2: MOV AH,01H
        INT 21H
        CMP AL,0DH
        JZ DIV_OPERATION
        MOV AH,0
        SUB AL,30H
        PUSH AX

        MOV AX,10D
        MUL BX
        POP BX
        ADD BX,AX
        JMP INPUT_NUM2

DIV_OPERATION:  
        POP AX
        DIV BX ; actual division takes place here
        PUSH DX ; push remainder to stack
        PUSH AX ; push quotient to stack

        LEA DX,QUOTIENT
        MOV AH,09H
        INT 21H
        POP AX
        MOV CX,0
        MOV DX,0
        MOV BX,10D

SPLIT_Q_DIGITS:  
        DIV BX
        PUSH DX
        MOV DX,0
        INC CX
        OR AX,AX
        JNZ SPLIT_Q_DIGITS

PRINT_QUOTIENT: 
        POP DX
        ADD DL,30H
        MOV AH,02H
        INT 21H
        LOOP PRINT_QUOTIENT

        LEA DX,REMAINDER
        MOV AH,09H
        INT 21H
        POP AX
        MOV CX,0
        MOV DX,0
        MOV BX,10D

SPLIT_R_DIGITS: 
        DIV BX
        PUSH DX
        MOV DX,0
        INC CX
        OR AX,AX
        JNZ SPLIT_R_DIGITS

PRINT_REMAINDER:  
        POP DX
        ADD DL,30H
        MOV AH,02H
        INT 21H
        LOOP PRINT_REMAINDER

        MOV AH,4CH ; exit
        INT 21H
    CODE ENDS 
END START