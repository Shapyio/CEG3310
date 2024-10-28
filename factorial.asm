.ORIG x3000

; initialize runtime stack
LD R6, STACK_BOTTOM		; R6 = x6000

; push main's return address
ADD R6, R6, #-1			; R6 = x5FFF
STR R7, R6, #0

; push previous frame pointer
ADD R6, R6, #-1			; R6 = x5FFE
STR R5, R6, #0
ADD R5, R6, #0			; R5 = x5FFE

; push int n
ADD R6, R6, #-1			; R6 = x5FFD
AND R0, R0, #0			; R0 = x0000
ADD R0, R0, #6			; R0 = 6
STR R0, R6, #0

; push int result
ADD R6, R6, #-1			; R6 = x5FFC

; call factorial(n)
ADD R6, R6, #-1			; R6 = x5FFB
STR R0, R6, #0

JSR FACTORIAL

STACK_BOTTOM .FILL x6000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FACTORIAL

; push factorial's return value
ADD R6, R6, #-1			; R6 = x5FFA

; push factorial's return address
ADD R6, R6, #-1			; R6 = x5FF9
STR R7, R6, #0

; push previous frame pointer
ADD R6, R6, #-1			; R6 = x5FF8
STR R5, R6, #0
ADD R5, R6, #0			; R5 = x5FF8

; push R0
ADD R6, R6, #-1			; R6 = x5FF7
STR R0, R6, #0

; push R1
ADD R6, R6, #-1			; R6 = x5FF6
STR R1, R6, #0

; push R2
ADD R6, R6, #-1			; R6 = x5FF5
STR R2, R6, #0

; push R3
ADD R6, R6, #-1			; R6 = x5FF4
STR R3, R6, #0

; check for base case
LDR R0, R5, #3			; R0 = int x
BRz RETURN_1
ADD R0, R0, #-1			; R0 = int x - 1
BRz RETURN_1

; execute general case
; push int x for next factorial (aka x - 1)
ADD R6, R6, #-1			; R6 = x5FF3
STR R0, R6, #0

JSR FACTORIAL

LDR R1, R6, #0			; R1 = factorial(x-1)'s return value
ADD R6, R6, #2			; R6 = x5FF4

AND R2, R2, #0			; R2 = 0

MULTIPLY
ADD R2, R1, R2
ADD R0, R0, #-1
BRzp MULTIPLY

ADD R0, R2, #0			; R0 = R2
BRnzp RETURN_ALL

RETURN_1
AND R0, R0, #0			; R0 = 0
ADD R0, R0, #1			; R0 = 1

RETURN_ALL
; overwrite return value with R0
STR R0, R5, #2

; pop R3
LDR R3, R6, #0
ADD R6, R6, #1			; R6 = x5FF5

; pop R2
LDR R2, R6, #0
ADD R6, R6, #1			; R6 = x5FF6

; pop R1
LDR R1, R6, #0
ADD R6, R6, #1			; R6 = x5FF7

; pop R0
LDR R0, R6, #0
ADD R6, R6, #1			; R6 = x5FF8

; pop previous frame pointer (R5)
LDR R5, R6, #0
ADD R6, R6, #1			; R6 = x5FF9

; pop factorial's return address (R7)
LDR R7, R6, #0
ADD R6, R6, #1			; R6 = x5FFA

RET

.END