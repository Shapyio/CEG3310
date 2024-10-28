; PART 1 - Exponent
.ORIG x3000

; Load variables
LD R0, xVal ; R0 -> x (inner loop counter)
LD R1, yVal ; R1 -> y (outer loop counter)
LD R2, xVal ; R2 -> z (final value), initialized to x
LD R3, ZERO ; R3 -> accumulate product (for z)

; --- Main ---
ADD R1, R1, #-1
OUTER_LOOP
BRz END_OUTER ; If y == 0, break

; Initialize x to 3 for the inner loop
LD R0, xVal ; R0 -> x (inner loop counter)

; Repeat inner loop process y times
  INNER_LOOP
  BRz END_INNER

  ADD R3, R3, R2 ; Add z to itself x times (stored in accumulate)
  ADD R0, R0, #-1; Decrement x

  BRnzp INNER_LOOP
  END_INNER

ST R3, zVal ; Store accumulate into zVal
LD R2, zVal ; Load the new value of z into R2
LD R3, ZERO ; Reset R3 to 0
ADD R1, R1, #-1 ; Decrement y

BRnzp OUTER_LOOP
END_OUTER

; Storing results to memory location x8000
STI R2, RESULT ; Store z into RESULT

HALT

; Giving variables values
xVal .FILL #3
yVal .FILL #4
zVal .FILL #0

ZERO .FILL #0

RESULT .FILL x8000

.END

; PART 2 - FOR
.ORIG x3000

AND R0, R0, #0      ; Reset R0 (counter)
AND R3, R3, #0      ; Reset R3 (results)

; Get loop iteration count maximum
LD R1, TEN          ; R1 is max i

; Load value of FIVE into a register
LD R2, FIVE         ; Load the value of FIVE into R2

; -----Main-----
START_LOOP
; Two's complement to check if i < 10
NOT R4, R0          ; Compute -R0
ADD R4, R4, #1      ; R4 = -R0 (Two's complement)
ADD R4, R4, R1      ; R4 = -R0 + R1 (Check if R0 < R1)
BRn END_LOOP       ; GOTO End of loop if R0 >= R1

; For Loop Code Block
ADD R3, R3, R2      ; Add 5 to R3, every iteration
ADD R0, R0, #1      ; Increment counter by 1

BRnzp START_LOOP    ; Continue loop

END_LOOP
; Store result
LEA R5, RESULT      ; Load effective address of RESULT into R5
STI R3, RESULT      ; Store the value of R3 at the address in RESULT

HALT

RESULT .FILL x8001
TEN .FILL #10
FIVE .FILL #5

.END

; PART 3 - If Else
.ORIG x3000

; Load variables
LD R0, xVal
LD R1, yVal

; --- Main ---
NOT R1, R1 ; 2s Complement
ADD R1, R1, #1 ; Add 1 to get: R1 - 1
ADD R2, R0, R1

BRz IF_TRUE ; IF R0 = R1
BRnzp ELSE

IF_TRUE ; True cond
LD R3, FIVE
BRnzp END_IF

ELSE ; False cond
LD R3, NEG_FIVE

END_IF ; End

; Store result
STI R3, RESULT
; ----------

HALT

; Giving variables values
RESULT .FILL x8002

xVal .FILL #12
yVal .FILL #10

FIVE .FILL #5
NEG_FIVE .FILL #-5

.END

; PART 4 - Array
.ORIG x3000

; Load variables
LD R5, ARR_SIZE ; Array size (loop counter)
LEA R1, ARRAY ; Array

; --- Main ---
LOOP
BRz END_LOOP

; - Output Prompt -
LEA R0, PROMPT ; R6 will hold user input prompt
PUTS ; Display string

; - User Input -
GETC ; Read character from user
OUT ; Echo (print character)

LD R0, NEWLINE
OUT

; - Convert ASCII user input to number -
LD R4, ASCII_REDUCE ; Load x0030
NOT R4, R4 ; Inverse
ADD R4, R4, #1 ; Add 1 for two's complement
ADD R3, R0, R4 ; Subtract R0 (user input) - R4 (x0030)

STR R3, R1, #0 ; Store number into array pointer location

ADD R1, R1, #1 ; Move array pointer to next element
ADD R5, R5, #-1 ; Decrement loop counter

BRnzp LOOP
END_LOOP
; ----------

HALT

ARR_SIZE .FILL #5 ; n (size of array) = 5
ARRAY .BLKW #5 ; Reserve 5 spaces for actual array
PROMPT .STRINGZ "Enter a number: " ; Prompt for user input
NEWLINE .FILL x000A
ASCII_REDUCE .FILL x0030
ZERO .FILL #0

.END