;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.ORIG x3000
;	Your main() function starts here
LD R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6	(R6 = x6000)
LEA R4, GLOBAL_VARS		;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))

; Note: The "!" implies its a instruction regarding the stack. Useful when using CTRL + F to find stack specific instructions.

; Register tracker:
; R0 - Multi-use
; R1 - Multi-use
; R2 - MAX_ARRAY_SIZE
; R3 - Counter register
; R4 - Global variables
; R5 - Frame pointer
; R6 - Stack pointer
; R7 - Return address

; !!!Top of stack is the return value of program (R6 = x6000)
; !Storing MAIN's return address
ADD R6, R6, #-1							; !Move stack pointer down 1 (for storing MAIN's return address) (R6 = x5FFF)
STR R7, R6, #0							; !Storing R7 (return address) to stack
; !Storing previous frame pointer
ADD R6, R6, #-1							; !Move pointer (R6 = 5FFE)
STR R5, R6, #0							; !Storing R5 (frame pointer) to stack
; !Setting current frame pointer
ADD R5, R6, #0							; !R5 = x5FFE
; !Storing local variables
ADD R6, R6, #-2							; !-2 for both array and total variables (R6 = 5FFD (GLOBAL_VARS) and 5FFC (Total))

; Load and store global variables
ADD R0, R4, #0							; R0 = Beginning of address of array (x3004 = MAX_ARRAY_SIZE and x3005 = ARRAY_POINTER)
STR R0, R5, #-1							; R0 = x3004 = global variable(s), stored at x5FFD

; !Push parameters to SUMOFSQUARES --- Start of SUMOFSQUARE Frame
ADD R6, R6, #-1							; !Allocating space for a[] from the C code (R6 = 5FFB)
LDR R0, R4, #-1							; !Move frame pointer (R0 = R5 = x5FFD -> array address)
STR R0, R6, #0							; !Storing a[] at x5FFB
ADD R6, R6, #-1							; !Allocating space for array size
LDR R0, R4, #0							; Loading MAX_ARRAY_SIZE
STR R0, R6, #0							; Storing MAX_ARRAY_SIZE (arraySize in C code) at address x5FFA

; !Allocating return value space
ADD R6, R6, #-1							; !(R6 = x5FF9)
JSR SUMOFSQUARES						;	CALL sumOfSquares() function

; !Pop the return value of SUMOFSQUARES and store it into the TOTAL variable (x5FFC)
LDR R0, R6, #0							; Load return value (sum of squares) from x5FF9 into R0
STR R0, R5, #2							; Store the final result in top of stack (x6000) (R5 = x5FFE)

; !Restore frame pointer and return address
ADD R6, R6, #1							; !Move stack up (R6 = x5FFA)
ADD R6, R6, #4							; !Pop local variables (R6 = x5FFE)
LDR R5, R6, #0							; !Restore frame pointer
ADD R6, R6, #1							; !Move stack up
LDR R7, R6, #0							; !Restore return address
ADD R6, R6, #1							; !Move stack up (R6 = x6000)

HALT

GLOBAL_VARS					;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005	;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002	;	ARRAY_POINTER points to the top of your array (5 elements)
				.FILL x0003
				.FILL x0005
				.FILL x0000
				.FILL x0001
STACK_PTR		.FILL x6000	;	STACK_PTR is a pointer to the bottom of the stack (x6000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SUMOFSQUARES

; !Stack managment for SQUARE subroutine
; !Store return address
ADD R6, R6, #-1							; !Memory space for return address (R6 = x5FF8)
STR R7, R6, #0							; !Save R7 (return address)
; !Save previous frame pointer
ADD R6, R6, #-1							; !Memory space for frame pointer (R6 = x5FF7)
STR R5, R6, #0							; !Save R5 (frame pointer)
ADD R5, R6, #0							; !Set new frame pointer (R5 = x5FF7)
; !Allocating space for old registers
ADD R6, R6, #-1							; !Allocating space for R0 (R6 = x5FF6)
STR R0, R6, #0							; !Storing R0
ADD R6, R6, #-1							; !Allocating space for R1 (R6 = x5FF5)
STR R1, R6, #0							; !Storing R1
ADD R6, R6, #-1							; !Allocating space for R2 (R6 = x5FF4)
STR R2, R6, #0							; !Storing R2
ADD R6, R6, #-1							; !Allocating space for R3 (R6 = x5FF3)
STR R3, R6, #0							; !Storing R3

LDR R2, R5, #4							; Loading MAX_ARRAY_SIZE into R2
LDR R1, R5, #3							; Loading MAX_ARRAY_SIZE
AND R2, R2, #0							; Clearing sum

SUM_LOOP
BRn END_SUM_LOOP

; !Pushing parameters to SQUARE into stack
ADD R6, R6, #-1							; !Allocating space for x (value to square in C code) --- Start of SQUARE frame (R6 = x5FF1)
JSR SQUARE
LDR R3, R6, #0							; Load the product of SQUARE
ADD R6, R6, #1							; !Pop SQUARE's return value (R6 = x5FF1)
ADD R6, R6, #1							; !Pop x (value to square in C code) --- End of SQUARE frame (R6 = x5FF2)

ADD R2, R3, #0							; Add R3 (Square product of index element) to R2 (sum of all squares)

ADD R1, R1, #-1							; Decrement counter

BRnzp SUM_LOOP
END_SUM_LOOP

; Store sum result
STR R2, R5, #2							; Store sum result at current frame pointer (sum -> R5 = x5FF9)

; !Pop local variable
ADD R6, R6, #2							; !Pop sum and counter (R6 = x5FF4)
; !Restore registers
LDR R2, R6, #0							; !Restore R2
ADD R6, R6, #1							; !Pop R2 (R6 = x5FF5)
LDR R1, R6, #0							; !Restore R1
ADD R6, R6, #1							; !Pop R1 (R6 = x5FF6)
LDR R0, R6, #0							; !Restore R0
ADD R6, R6, #1							; !Pop R0 (R6 = x5FF7)
; !Restore frame pointer
LDR R5, R6, #0							; !Restore R5 (frame pointer)
ADD R6, R6, #1							; !Pop frame pointer (R6 = x5FF8)
; !Restore return address
LDR R7, R6, #0							; !Restore R7 (return address)
ADD R6, R6, #1							; !Pop return address (R6 = x5FF9)

RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SQUARE

; !Stack managment for SQUARE 
; !Store return value of SQUARE
ADD R6, R6, #-1							; !Allocating space for return value of subroutine (R6 = x5FF0)
; !Store return address
ADD R6, R6, #-1							; !Memory space for return address (R6 = x5FEF)
STR R7, R6, #0							; !Save R7 (return address)
; !Save frame pointer
ADD R6, R6, #-1							; !Memory space for frame pointer (R6 = x5FEE)
STR R5, R6, #0							; !Save R5 (frame pointer) (R5 = x5FFE -> R6 = x5FEE)
ADD R5, R6, #0							; !Set new frame pointer (R5 = x5FEE)
; !Allocating space for old registers
ADD R6, R6, #-1							; !Allocating space for R0
STR R0, R6, #0							; !Storing R0
ADD R6, R6, #-1							; !Allocating space for R1
STR R1, R6, #0							; !Storing R1
ADD R6, R6, #-1							; !Allocating space for R2
STR R2, R6, #0							; !Storing R2
ADD R6, R6, #-1							; !Allocating space for R3
STR R3, R6, #0							; !Storing R3

AND R0, R0, #0							; Clearing R0
STR R0, R5, #-1							; Saving R0 (local variable) that holds product

LDR R1, R5, #

SQ_LOOP
BRn END_SQ_LOOP

ADD R1, R1, R0							; Add R0 to R1, the product (save to product)
ADD R4, R4, #-1							; Decrement the counter

BRnzp SQ_LOOP
END_SQ_LOOP

STR R1, R5, #2							; !Store the return value of SQUARE into the stack

; !Stack management for return to SUMOFSQUARES
; !Pop saved local registers/variables
ADD R6, R6, #1							; !Pop register local variable (product) (R6 = x5FEB)
LDR R2, R6, #0							; !Restoring R2
ADD R6, R6, #-1 						; !Move stack up (R6 = x5FEC)
LDR R1, R6, #0							; !Restoring R1
ADD R6, R6, #-1							; !Move stack up (R6 = x5FED)
LDR R0, R6, #0 							; !Restoring R0
ADD R6, R6, #-1 						; !Move stack up (R6 = x5FEE)
; !Pop old frame pointer
LDR R5, R6, #0							; !Pop R5 first, because order of stack
ADD R6, R6, #1							; !Move stack up (R6 = x5FEF)
; !Pop old return address
LDR R7, R6, #0							; !Pop R7 second, because we stored it before R5
ADD R6, R6, #1							; !Move stack up (R6 = x5FF0)

RET													; R6 = x5FF0 holds the result of the square

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.END