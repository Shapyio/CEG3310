.ORIG x3000 

; Subroutines should follow register in - register out. MUL, for instance, has two inputs and one output. Example:
;   LD R0, VAL_A
;   LD R1, VAL_B
;   JSR MUL ; Inputs R0 and R1, output R0
;   ST R0, RESULT
; MUL should back up all the registers it uses (especially R7!) except R0. It doesn't load the R0 backup because it 
; instead uses R0 to return.

; Critical subroutines for the lab:

; GETNUM has no register inputs, uses GETC to get two digits, turns those digits into a number, and returns that.
; Input "69" (in ascii x0036 x0039) should return the value x0045 (which is #69 in hex).
; Single digit inputs can either be padded with a 0 (like "05") or single digit then newline ("5\n").
; Make sure to have OUT after GETC so it shows in the console what you type.

; GETOP has no register inputs and returns an operand (either the ascii value of *, +, - or some other way).
; The important part is that GETOP's output must correctly tell CALC what operation to do!
; Make sure to have OUT after GETC so it shows in the console what you type.

; CALC has three register inputs: the two numbers and the operation. Order doesn't matter as long as it works.
; The thing returned from GETOP should be compatible with CALC. 

; DISPLAY has one register input and no register output. It converts its input number to ascii and prints it.
; Must support both negative and positive numbers with a range [-9999, 9999] inclusive.
; If the input to DISPLAY is x01A4 (which is #420), it should print "420" or "0420" to console.
; If the input to DISPLAY is xFB2E (#-1234), it should print out "-1234". 

; Feel free to make and use other subroutines. Remember to back up R7. Remember to loop the main program infinitely.
; Good luck!

.END

.ORIG x3000
; - User input -
LEA R0, PROMPT1		        ; Load the first number prompt and display to the user
PUTS
JSR GETNUM                ; Get first number
ST R1, NUM1               ; R1 is the register where the final number is saved, so save R1 to NUM1

HALT

PROMPT1 .STRINGZ "Enter first number (0 - 99): "

ASCII_REDUCE .FILL #-48
TEN .FILL #10

NUM1 .BLKW #1
NUM2 .BLKW #1

GETNUM
    ; Constants
    LD R3, ASCII_REDUCE      ; Load ASCII Reduce value to parse user input
    LD R4, TEN               ; Load constant 10

    ; First digit
    GETC                     ; Get first digit from user
    OUT                      ; Echo
    ADD R0, R0, R3           ; Convert from ASCII to integer (#48 = x0030 = '0')
    ADD R1, R0, #0           ; Store integer in R1

    ; Second digit
    GETC                     ; Get second digit from user
    OUT                      ; Echo
    ADD R0, R0, R3           ; Convert ASCII to integer

    ; Multiply first digit by 10 (R1 = R1 * 10)
    AND R2, R2, #0           ; Clear R2 (used for loop counter)
    ADD R2, R2, R4           ; Set R2 to 10
MULT_LOOP
    ADD R1, R1, R1           ; Double R1 each iteration (equivalent to R1 * 2)
    ADD R2, R2, #-1          ; Decrement R2
    BRp MULT_LOOP            ; Continue until R2 reaches 0

    ; Adjust for correct multiplication by 10
    ADD R1, R1, R1           ; R1 = R1 * 2 (Now R1 is multiplied by 8)
    ADD R1, R1, R0           ; Add original R1 value to achieve R1 * 10

    ; Adding second digit
    ADD R1, R1, R0           ; Adding second digit to form the number

    RET

.END