ORIGIN 4x0000

; R0 <- 0 for resetting values 
; R1 <- negative 1 for decrementing counters
; R2 <- the sum of the values for each iteration of the big loop
; R3 <- the value that is added each iteration of the small loop
; R4 <- the counter for the big loop
; R5 <- the counter for the small loop

SEGMENT  CodeSegment:


	LDR  R3, R0, INPUT	; R3 <- #, the output is #!
	NOT  R1, R0			; R1 <- negative 1
	ADD  R2, R0, R0		; R2 <- initialize to 0
	ADD  R4, R3, R1		; R4 <- one below the factorial value for the big loop
	ADD  R5, R3, R1		; R5 <- one below the factorial value for the small loop
LOOP1:					
	ADD  R2, R2, R3		; add the current adder value to the sum value
	ADD  R5, R5, R1		; decrement the small loop counter
	BRp  LOOP1			; loop back for small loop
	ADD  R3, R2, R0		; if small loop is done then change the adder value to the sum value
	ADD  R2, R0, R0		; reset the sum value
	ADD  R5, R4, R1		; reset the small loop counter to the new big loop value
	ADD  R4, R4, R1		; decrement the big loop counter
	BRp  LOOP1			; loop back for big loop
	
	STR  R3, R0, RESULT	; store the answer in result
	

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.

INPUT:		DATA2 4x0005
RESULT:		DATA2 4x0000
