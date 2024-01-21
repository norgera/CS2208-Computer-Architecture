AREA VerifyUPC, CODE, READONLY ; Define the assembly execution region
             ENTRY                          ; Program entry point
			 
             MOV r4, #zero                  ; Initialize register for odd digit sum
             MOV r5, #zero                  ; Initialize register for even digit sum
             MOV r3, #loopAmount            ; Initialize register for odd-even checker/decrementer
             ADR r1, UPC                    ; Set r1 to point to the UPC string in memory
			 
                                            ; Parse String, accumulate integer sums for odd and even digits								
addSum       LDRB r2, [r1], #1              ; Load the ASCII digit from the UPC string and advance position
             SUB r2, #asciiDiff             ; Convert ASCII digit to integer value (explained in constants section)
             TST r3, #oddBit                ; Check if odd/even checker is 0
             ADDNE r4, r2                   ; If checker is 0, add odd digit (first, third, ...) to r4 (odd sum)
             ADDEQ r5, r2                   ; Otherwise, add even digit (second, fourth, ...) to r5 (even sum)
             SUBS r3, #1                    ; Decrement odd-even checker by 1
             BPL addSum                     ; If counter is still positive, branch back to addSum to continue accumulation
			 
                                            ; Finished Accumulating, calculate totals
finish       ADD r4, r4, LSL#1              ; Multiply the odd sum by 3 (odd + odd * 2) 
             ADD r5, r4                     ; Add the odd sum to the even sum
			 
                                            ; Modulo Loop
modulo       CMP r5, #0                     ; Check if even sum is greater than 0
             SUBGTS r5, #moduloAmount       ; If so, subtract 10
             BGT modulo                     ; If it's still greater than 0, branch back to modulo to continue subtraction
			 
                                            ; Final Result
result       MOVPL r0, #upcValid            ; If even sum is non-negative, it's a valid UPC (r0 is 1)
             MOVMI r0, #upcInvalid          ; If not, it's an invalid UPC (r0 is 2)
			 
loop         B loop                         ; Infinite loop

                                            ; UPC Strings
UPC          DCB "013800150738"             ; Correct UPC string
UPC2         DCB "060383755577"             ; Correct UPC string
UPC3         DCB "065633454712"             ; Correct UPC string

                                            ; Constants
zero         EQU 0                          ; zero
asciiDiff    EQU 0x30                       ; ASCII to integer difference (e.g., 0x35 - 0x30 = 0x5, which equals 5)
upcValid     EQU 1                          ; Signal for a valid UPC
upcInvalid   EQU 2                          ; Signal for an invalid UPC
loopAmount   EQU 11                         ; Number of times the loop will run (11 iterations for 12 digits)
moduloAmount EQU 10                         ; Modulo amount (used for subtraction)
oddBit       EQU 0x1                        ; Bit to test for odd numbers

             END                            ; End program
