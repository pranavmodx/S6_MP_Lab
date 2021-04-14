ASSUME DS:DATA,CS:CODE 
; mandatory starting code to let assembler know of segment name and register

DATA SEGMENT
FIRST DB 0AH,0DH,"Enter 1st Number:$"
SECOND DB 0AH,0DH,"Enter 2nd Number:$"
RESULT DB 0AH,0DH,"The Sum is:$"
DATA ENDS
;0AH is line break, 0DH is carriage return
;"$" is used as line end

CODE SEGMENT
START: ; label - not necessary but easier to identify different parts of code
	MOV AX,DATA ; store data segment's base address in DS register via AX
	MOV DS,AX 

	LEA DX,FIRST ; load effective address of string 'FIRST' into DX
	MOV AH,09H ; write string to stdout; done by storing 09H function code to AH
	INT 21H ; call interrupt 21H to perform the function
	; AH stores the function code ; AL stores the result of function

	MOV AH,01H ; read 1st digit of 1st no
	; each digit is read as a character by processor as stores it in register in ASCII code
	; '0' is 30H in ASCII, '1' is 31H, etc
	INT 21H
	MOV BH,AL
	MOV AH,01H ; read 2nd digit of 1st no
	INT 21H
	MOV BL,AL
	; BX (BH, BL) is storing the 1st no

	LEA DX,SECOND
	MOV AH,09H
	INT 21H

	MOV AH,01H ; read 1st digit of 2nd no
	INT 21H
	MOV CH,AL
	MOV AH,01H ; read 2nd digit of 2nd no
	INT 21H
	MOV CL,AL
	; CX (CH, CL) is storing the 2nd no
	
	MOV AH,00H ; clear AH since AAA will be performed on AX (avoid corruption of values)
	MOV AL,BL
	ADD AL,CL
	AAA	; ASCII Adjust after Addition; AAA works on what is loaded into AL
	; converts result of ASCII operand addition to number
	
	ADD AL,30H ; add 30 to result to obtain the ASCII code of the number
	MOV BL,AL
	MOV CL,AH ; move carry to CL

	MOV AH,00H ; clear AH
	MOV AL,BH
	ADD AL,CH
	AAA

	ADD AX,3030H 
	; convert to ASCII, here AH (which holds carry / hundred's place) 
	; is also converted before moving to CL, as it is to be printed
	; ASCII values are to be written to stdout in order to display the correct number
	ADD AL,CL ; add carry
	MOV BH,AL
	MOV CL,AH ; move carry / hundred's place to CL

	; hundreds tens ones
	; CL	   BH   BL

	LEA DX,RESULT
	MOV AH,09H
	INT 21H

	MOV DL,CL
	MOV AH,02H ; hundreds place
	INT 21H

	MOV DL,BH 
	MOV AH,02H ; tens place
	INT 21H

	MOV DL,BL
	MOV AH,02H ; one's place
	INT 21H

	MOV AH,4CH ; exit function code
	INT 21H

CODE ENDS
END START