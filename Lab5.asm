.ORIG x3000 ; MAIN() Function

; Setting up stack
LD R6, STACK_PTR            ; Loading stack pointer (R6 = x5013)
LEA R4, GLOBAL_VARS         ; R4 points to globasl variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADD R6, R6, #-1             ; Allocating room for return value (R6 = x5012)

STR R7, R6, #0              ; Store return address of MAIN (at x5012)
ADD R6, R6, #-1             ; Allocating space (R6 = x5011)

ADD R5, R6, #0              ; Setting frame pointer for local variables of MAIN (to x5011)
STR R5, R6, #0              ; Storing frame pointer (at x5011)
ADD R6, R6, #-1             ; Allocating space (R6 = x5010)
;;;;
; Output user input prompts
LEA R0, INPUT_PROMPT        ; Load output prompt
PUTS                        ; Print prompt
; Get n from user
LD R1, ASCII_REDUCE         ; Load ASCII Reduce to parse user input
GETC                        ; Get character (expected to be 0-9)
OUT                         ; Output inputted character
ADD R0, R0, R1              ; ASCII Reduce digit
STR R0, R6, #0              ; Storing user input n (at x5010) (Arguement passing to FIBONACCI)
; Push arguements into FIBONACCI subroutine
JSR FIBONACCI               ; Goto FIBONACCI subroutine (Results at x500F)
LDR R2, R5, #-2             ; Load result from FIBONACCI to R2
STR R2, R5, #2              ; Storing result to top of stack (x5013)
; At R6 = x5010 at this point...
; Printing results
LEA R0, PROMPT_PART1        ; Loading "F("
PUTS                        ; Printing ^
LDR R0, R5, #-1             ; Load value n
LD R1, ASCII_REDUCE         ; Load ASCII reduce to print n
NOT R1, R1                  ; Using two's complement to reverse ASCII REDUCE to be able to print
ADD R1, R1, #1
ADD R0, R0, R1              ; Converting n (stored in R0) back to printable format
OUT                         ; Printing n
LEA R0, PROMPT_PART2            ; Loading ") = "
PUTS                        ; Printing ^
ADD R3, R2, #0              ; Copy return value (from R2) to R3
AND R1, R1, #0              ; Clear R1

; Printing return value
PRINT_TENS                  ; Loop used to count number of 10s in return value
ADD R1, R1, #1              ; Increment R1 (counter)
ADD R3 R3, #-10             ; Decrement return value
BRzp PRINT_TENS             ; If not negative, means there are still 10s to decrement, loop again
ADD R1, R1, #-1             ; Checking to see if any 10 present before printing
BRz SKIP_TENS               ; Skip printing 10s if none present in R1
ADD R0, R1, #0              ; Moving R1 to R0 (because R0 prints)
LD R1, ASCII_REDUCE         ; Loading ASCII reduce
NOT R1, R1                  ; Using two's complement to reverse ASCII REDUCE to be able to print
ADD R1, R1, #1
ADD R0, R0, R1              ; Converting 10s place digit (stored in R0) back to printable format
OUT                         ; Print digit

SKIP_TENS
ADD R3, R3, #10             ; Add 10 to undo earlier subtraction
AND R1, R1, #0              ; Clear R1 (counter)
; Same process as above for 1s place
PRINT_ONES                  ; Loop used to count number of 10s in return value
ADD R1, R1, #1              ; Increment R1 (counter)
ADD R3 R3, #-1             ; Decrement return value
BRzp PRINT_ONES             ; If not negative, means there are still 1s to decrement, loop again
ADD R0, R1, #-1             ; Moving R1 to R0
LD R1, ASCII_REDUCE         ; Loading ASCII reduce
NOT R1, R1                  ; Using two's complement to reverse ASCII REDUCE to be able to print
ADD R1, R1, #1
ADD R0, R0, R1              ; Converting 10s place digit (stored in R0) back to printable format
OUT                         ; Print digit
; Popping stack
ADD R6, R6, #1              ; Pop (R6 = x5011)
LDR R5, R6, #0              ; Restoring pointer
ADD R6, R6, #1              ; Pop (R6 = x5012)
LDR R7, R6, #0              ; Restoring return address
ADD R6, R6, #1              ; Pop (R6 = x5013)
; ^Top of stack

HALT

GLOBAL_VARS
STACK_PTR .FILL x5013
INPUT_PROMPT .STRINGZ "Please enter a number n: "
ASCII_REDUCE .FILL #-48
PROMPT_PART1 .STRINGZ "\nF("
PROMPT_PART2 .STRINGZ ") = "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FIBONACCI ; Fibonacci Function
; F(n) = F(n-1) + F(n-2)
; Where, F(0) = 0 and F(1) = 1
;;;;
; Return value
ADD R6, R6, #-1             ; Allocating space for return value (R6 = x500F) 
; Saving return address
ADD R6, R6, #-1             ; Allocating space for return address (R6 = x500E) 
STR R7, R6, #0              ; Storing return address (at x500E)
; Saving frame pointer
ADD R6, R6, #-1             ; Allocating space (R6 = x500D) 
STR R5, R6, #0              ; Saving frame pointer
ADD R5, R6, #0              ; Setting new frame pointer (R5 -> x500D)
; Storing registers
ADD R6, R6, #-1             ; Allocating space (R6 = x500C)
STR R0, R6, #0              ; Storing R0 (at x500C)
ADD R6, R6, #-1             ; Allocating space (R6 = x500B)
STR R1, R6, #0              ; Storing R1 (at x500B)
ADD R6, R6, #-1             ; Allocating space (R6 = x500A)
STR R2, R6, #0              ; Storing R2 (at x500A)
ADD R6, R6, #-1             ; Allocating space (R6 = x5009)
STR R3, R6, #0              ; Storing R3 (at x5009)
ADD R6, R6, #-1             ; Allocating space (R6 = x5008) -8
;;;;
; BASE CASE
LDR R0, R5, #3              ; Load input arg (from x5010) into R0
ADD R1, R0, #-1             ; Check if R0 == 1 
BRz END_CASE                ; If result is zero, branch to END_CASE
ADD R0, R0, #1              ; Add 1 to R0
ADD R0, R0, #-1             ; Check if R0 == 0
BRz END_CASE                ; If result is zero, branch to END_CASE
; If neither base case, continue with general case

; GENERAL CASE
ADD R0, R0, #-1             ; Calculating n-1
STR R0, R6, #0              ; Storing n-1 (R0) to stack (at x5008)
JSR FIBONACCI
LDR R1, R5, #-6             ; Load return value into R1 (from x5007)

ADD R0, R0, #-1             ; Calculating (n-1)-1 = n-2 to R0
STR R0, R6, #0              ; Storing n-2 (R0) (at x5008)
JSR FIBONACCI
LDR R2, R5, #-6             ; Loading return value to R2 (from x5007)

ADD R0, R1, R2              ; Adding results from branches R1 + R2 = (n-1) + (n-2)
;;;;
END_CASE
STR R0, R5, #2              ; Storing R0 to return value of frame
; Restoring registers
ADD R6, R6, #1              ; Popping (R6 = x5009)
LDR R3, R6, #0              ; Restoring old R3 value
ADD R6, R6, #1              ; Popping (R6 = x500A)
LDR R2, R6, #0              ; Restoring old R2 value
ADD R6, R6, #1              ; Popping (R6 = x500B)
LDR R1, R6, #0              ; Restoring R1 
ADD R6, R6, #1              ; Popping (R6 = x500C)
LDR R0, R6, #0              ; Restoring R0
; Restoring frame pointer
ADD R6, R6, #1              ; Popping (R6 = x500D)
LDR R5, R6, #0              ; Loading old frame pointer
; Restoring return address
ADD R6, R6, #1              ; Popping (R6 = x500E)
LDR R7, R6, #0              ; Restoring return address
; Returning
ADD R6, R6, #2              ; Popping full stack (R6 = x500F), return value stored here
RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.END