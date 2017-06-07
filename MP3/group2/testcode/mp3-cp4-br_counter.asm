ORIGIN 0
SEGMENT
CODE:
	ADD R1, R1, 5
	ADD R2, R2, -5
	ADD R3, R1, R2			; NZP = 010
	NOP
	NOP
	NOP
	NOP
	NOP

	; Cache Line
	BRz ZEROTEST		; Test jumping to correct PC, branch, 0x0010 -> 0x0020
	ADD R1, R1, R1		;
	ADD R1, R1, R1
	ADD R1, R1, R1
	ADD R1, R1, R1
	ADD R1, R1, R1
	ADD R1, R1, R1
	BRnzp BADEND

	; Cache Line
ZEROTEST:
	ADD R2, R2, R2		; 0x0020
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2
	ADD R2, R2, R2		; NZP = 100
	BRzp BADEND			; Test Miss, don't branch, 0x002E
	; Cache Line
	ADD R3, R0, R0		; NZP = 010
	BRnp BADEND
	BRnp BADEND
	BRnp BADEND
	BRz TOEND1			; Test Multiple misses, TAKE THIS BRANCH, then test multiple, 0x0038 -> 0x0040
	BRnp BADEND
	BRnp BADEND
	BRnp BADEND
	; Cache Line
TOEND1:
	BRz TOEND2			; 0x0040 -> 0x0044
	BRnzp BADEND
TOEND2:
	BRz TOEND3			; 0x0044 -> 0x0048
	BRnzp BADEND
TOEND3:
	BRnp BADEND			; 0x0048
	BRz GOODEND			; 0x004a -> 0x004e
	ADD R5, R5, 5		; Should not reach here
GOODEND:
	BRNZP TESTCOUNTER
	; Cache Line		0x0050
BADEND:
	ADD R7, R7, 1
	ADD R7, R7, R7
	ADD R7, R7, R7
	ADD R7, R7, R7
	ADD R7, R7, R7
	ADD R7, R7, R7
	BRNZP BADEND
	NOP
	; Cache Line		0x0060
TESTCOUNTER:
	; Reset Registers
	ADD R1, R0, R0
	ADD R2, R0, R0
	ADD R3, R0, R0
	ADD R4, R0, R0
	ADD R5, R0, R0
	ADD R6, R0, R0
	ADD R7, R0, R0
	LDR	R1, R0, -16		; miss br, should be 5
	; Cache Line		0x0070
	LDR	R2, R0, -15		; br, should be 11/0xB
	STR R0, R0, -16		; reset miss br
	STR R0, R0, -15		; reset br
	ADD R0, R0, R0		; Set CC to ZEROTEST
	BRp BADEND
	BRnzp TESTCOUNTERTEST2
TESTCOUNTERTEST2:
	LDR	R3, R0, -16		; miss br, should be 1
	LDR	R4, R0, -15		; br, should be 2
	; Cache Line		0x0080
FINISH:
	BRnzp FINISH

SEGMENT
DATA:
VAL0:	DATA2 4x1234
ABCD:	DATA2 4xABCD
FFFF:	DATA2 4xFFFF
LW56:	DATA1 4x56
HI78:	DATA1 4x78
LWST:	DATA1 ?
HIST:	DATA1 ?
