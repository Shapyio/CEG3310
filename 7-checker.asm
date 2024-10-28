.ORIG   x3000

MAIN_LOOP
LEA R0, PROMPT      ; Load address of the prompt message
PUTS                ; Display the prompt message
GETC                ; Get the single character input from the user
OUT                 ; Echo the input back to the user
LD R1, ASCII_REDUCE ; Load the ASCII value of '0'
NOT R1, R1          ; Two's Complement
ADD R1, R1, #1
ADD R0, R0, R1      ; Convert ASCII character to integer (subtract ASCII '0')

ADD R2, R0, #0      ; Copy the input number to R2 for comparison

ADD R3, R0, #-7     ; Compare input with 7 (R0 - 7)
BRz EQUAL_SEVEN     ; If input == 7, branch to EQUAL_SEVEN
BRn LESS_THAN_SEVEN ; If input < 7, branch to LESS_THAN_SEVEN

GREATER_THAN_SEVEN
LEA R0, GT7MSG      ; Load address of "greater than 7" message
PUTS                ; Print the message
BR MAIN_LOOP        ; Go back to main loop

LESS_THAN_SEVEN
LEA R0, LT7MSG      ; Load address of "less than 7" message
PUTS                ; Print the message
BR MAIN_LOOP        ; Go back to main loop

EQUAL_SEVEN
LEA R0, EQ7MSG      ; Load address of "equal to 7" message
PUTS                ; Print the message
BR MAIN_LOOP        ; Go back to main loop

PROMPT  .STRINGZ "Enter a single digit number (0-9): "
LT7MSG  .STRINGZ "\nThe number you entered was less than 7!\n"
EQ7MSG  .STRINGZ "\nThe number you entered was equal to 7!\n"
GT7MSG  .STRINGZ "\nThe number you entered was greater than 7!\n"

ASCII_REDUCE .FILL x0030       ; ASCII reducer

.END
