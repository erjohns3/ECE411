ORIGIN 0
SEGMENT
CODE:
	LEA R0, DATA
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	LDR R3, R0, 3		; Make sure target value is 0x0074
	LDI R1, R0, 3		; Now test knowing that target is 0x600d
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	ADD R1, R1, 1		; Increment before store, so we can make sure we load the value again
	ADD R0, R0, 2		; Change offset
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	STI R1, R0, 2		; Store with new value and different offset
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	LEA R0, DATA
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	LDR R5, R0, GOOD	; Test final load

GOODEND:
	BRnzp GOODEND
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP


SEGMENT
DATA:
VAL0:	DATA2 4x0010	;102
VAL1:	DATA2 4x0011	;104
VAL2:	DATA2 4x0012	;106
GVAL:	DATA2 4x0074	;108		-- Correct target
VAL4:	DATA2 4x0014	;110
VAL5:	DATA2 4x0015	;112
VAL6:	DATA2 4x0016	;114
GOOD:	DATA2 4x600D	;116
VAL8:	DATA2 4x0018	;118
VAL9:	DATA2 4x0019	;120
