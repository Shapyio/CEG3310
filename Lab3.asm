; Lab 3
; Shapiy Sagiev
; CEG3310 - Computer Organization
; Prof. Max Gilson

.ORIG x3000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN_LOOP                 ; Loop structure

; - User input -
LEA R0, PROMPT1		        ; Load the first number prompt and display to the user
PUTS
JSR GETNUM                ; Get first number
ST R0, NUM1               ; R1 is the register where the final number is saved, so save R1 to NUM1

LD R0, NEWLINE
OUT

LEA R0, PROMPT2		        ; Load the operator prompt and display to the user
PUTS
JSR GETOP                 ; Get second number
                          ; No need to save here, because subroutine directly saves it already :D

LD R0, NEWLINE
OUT

LEA R0, PROMPT3		        ; Load the second number prompt and display to the user
PUTS
JSR GETNUM                ; Get second number
ST R0, NUM2               ; R1 is the register where the final number is saved, so save R1 to NUM2

LD R0, NEWLINE
OUT

; - Calculate -
JSR CALC

; - Display Results -
LEA R0, PROMPT4		        ; Load the results prompt and display to the user
PUTS

LD R0, NEWLINE
OUT

BRnzp MAIN_LOOP           ; BRnzp with no exit condition because no exit is needed

HALT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PROMPT1 .STRINGZ "Enter first number (0 - 99): "
PROMPT2 .STRINGZ "Enter an operation (+, -, *): "
PROMPT3 .STRINGZ "Enter second number (0 - 99): "
PROMPT4 .STRINGZ "Result: "
NEWLINE .FILL x000A

NUM1 .BLKW #1
NUM2 .BLKW #1
OP .BLKW #1
RESULT .BLKW #1

; Custom Variables
ASCII_REDUCE .FILL #-48
ASCII_RESTORE .FILL #48
TEN .FILL #10
ZERO .FILL x0030
BUFFER .BLKW #5
NEG_FORTY_THREE .FILL #-43
MAX_BIT .FILL #255

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GETNUM

ADD R6, R7, #0            ; Save R7 to jump back to MAIN code

; Load needed variables
LD R3, ASCII_REDUCE       ; Load ASCII Reduce to parse user input

; First digit
GETC
OUT
ADD R0, R0, R3            ; ASCII Reduce first digit
ADD R1, R0, #0            ; Move first digit to R1

; Second digit
GETC
OUT
ADD R0, R0, #-10          ; Check for newline
BRz END_GETNUM
ADD R2, R0, #10           ; Put back from newline check
ADD R2, R2, R3            ; Convert from ASCII

; Multiply first digit by 10
AND R3, R3, #0            ; Clear R3 for iterate
ADD R3, R3, #9

ADD R4, R1, #0            ; Store input for what to add in loop

LOOP
ADD R1, R1, R4            ; Add R1 and R4, store value -> R1
ADD R3, R3, #-1           ; Decrement loop
BRp LOOP

ADD R0, R1, R2            ; Add First digit * 10 + Second digit

END_GETNUM
ADD R7, R6, #0            ; Restore R7 to old address of MAIN
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GETOP

ADD R6, R7, #0            ; Save R7 to jump back to MAIN code

; Operator
GETC                      ; Get operator from user (either +, -, or *)
OUT                       ; Echo

ST R0, OP                 ; Save operator to OP variable

ADD R7, R6, #0            ; Restore R7 to old address of MAIN

RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CALC
ADD R6, R7, #0            ; Save R7 to jump back to MAIN code

LD R0, NUM1               ; Load variables into R0 through R2
LD R1, NUM2
LD R2, OP
LD R4, NEG_FORTY_THREE    ; Loading -43 for next calculation to determine what operation to run

ADD R3, R2, R4            ; Subtract 43 to figure out what OP
                          ; "+"=43, "-"=45, "*"=42, so 43-43=0 (BRz) goes to addition subr., 45-43=2 (BRp) goes to subtract subr., and 42-43=-1 (BRn) goes to multiplication subr.
BRn MUL_OP
BRz ADD_OP
BRp SUB_OP

; - Addition -
ADD_OP
ADD R0, R0, R1            ; Simply add R0 and R1

ST R0, RESULT             ; Save R0 to RESULT

ADD R7, R6, #0            ; Restore R7 to old address of MAIN

RET

; - Subtraction -
SUB_OP                    
                          ; Two's Complement
NOT R1, R1                ; Inverse
ADD R1, R1, #1            ; Add 1
ADD R0, R0, R1            ; Add R1 to R0

ST R0, RESULT             ; Save R0 to RESULT

ADD R7, R6, #0            ; Restore R7 to old address of MAIN

RET

; - Multiplication -
MUL_OP
AND R2, R2, #0            ; Clear R2

LOOP_MUL
ADD R2, R2, R0            ; Add R0 to R2
ADD R1, R1, #-1           ; Decrement count
BRp LOOP_MUL

ST R2, RESULT             ; Save R2 to RESULT

ADD R7, R6, #0            ; Restore R7 to old address of MAIN

RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY ; TODO: Fix display function...
ADD R6, R7, #0            ; Save R7 to jump back to MAIN code

LD R0, RESULT             ; Load result into R0
LD R2, ASCII_RESTORE      ; To convert back to ASCII

; Check if the result is 0
BRz DISPLAY_ZERO

; Prepare for number to string conversion
LEA R5, BUFFER            ; Load the address of the buffer
ADD R4, R0, #0            ; Copy the result to R4
AND R1, R1, #0            ; Clear R1

DISPLAY_LOOP
JSR MODULO10              ; Jump to MODULO10 subroutine
ADD R1, R0, R2            ; Convert to ASCII
STR R1, R5, #-1           ; Store in buffer
ADD R5, R5, #-1           ; Move buffer pointer
AND R0, R0, #0            ; Clear R0
BRp DISPLAY_LOOP          ; Continue loop if not done

; Print the number
LEA R0, BUFFER
PUTS

BRnzp DISPLAY_END

DISPLAY_ZERO
LD R0, ZERO
OUT

DISPLAY_END
ADD R7, R6, #0            ; Restore R7 to old address of MAIN
RET

MODULO10
AND R0, R0, #0            ; Clear R0 for quotient
AND R1, R1, #0            ; Clear R1 for remainder
LD R3, TEN                ; Load 10 to R3
ADD R2, R4, #0            ; Copy R4 to R2

DIV_LOOP
NOT R3, R3                ; Take two's complement of 10
ADD R3, R3, #1            ; to subtract it
ADD R2, R2, R3            ; Subtract 10 from R2
NOT R3, R3                ; Restore R3 to 10
ADD R3, R3, #-1
BRn MODULO_DONE
ADD R0, R0, #1            ; Increment quotient
BRnzp DIV_LOOP            ; Continue loop

MODULO_DONE
NOT R3, R3                ; Take two's complement of 10 again
ADD R3, R3, #1
ADD R2, R2, R3            ; Undo last subtraction that made it negative
ADD R4, R2, #0            ; Update R4 to the correct remainder
LD R1, MAX_BIT            ; Load 255
AND R4, R4, R1            ; Ensure R4 is positive

RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.END