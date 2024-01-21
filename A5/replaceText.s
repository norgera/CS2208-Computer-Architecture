          AREA QUESTION, CODE, READONLY
          ENTRY
                                              ; Initialize and set up registers
          ADR r0, STRING1                     ; Point to the original string
          ADR r1, STRING2                     ; Point to the location to store the final string
          MOV r2, #-1                         ; Initialize the pointer incrementer

                                              ; Read and increment characters
Read      ADD r2, #1                          ; Increment the pointer
          MOV r3, r2                          ; Copy the pointer to r3
          LDRB r4, [r0, r2]                   ; Load the character into r4
          MOV r5, r4                          ; Copy the character to r5

                                              ; Load character and check for any occurrence of "the"
Check     CMP r4, #t                          ; Check for 't'
          SUBEQ r3, #1                        ; Decrement pointer for space (0x20)
          LDRBEQ r4, [r0, r3]                 ; Load that character
          CMPEQ r4, #spc                      ; Check for space
          ADDEQ r3, #2                        ; Increment pointer twice for 'h' (going backward to check space, then forward for the rest)
          LDRBEQ r4, [r0, r3]                 ; Load the next character
          CMPEQ r4, #h                        ; Check 'h'
          ADDEQ r3, #1                        ; Increment pointer for 'e'
          LDRBEQ r4, [r0, r3]                 ; Load the next character
          CMPEQ r4, #e                        ; Check 'e'
          ADDEQ r3, #1                        ; Increment pointer for space
          LDRBEQ r4, [r0, r3]                 ; Load the next character
          CMPEQ r4, #spc                      ; Check space
          ADDEQ r2, #2                        ; Skip characters if "the" matches
          BEQ Read                            ; Go back to Read to read the next characters
          
          CMPNE r4, #null                     ; Compare if null character
          STRBNE r5, [r1], #1                 ; Store the copied character (r5) if it does not match "the" cases and is not a null character
          BNE Read                            ; Go back to Read if it does not match

Loop      B Loop                              ; Finish the loop

                                              ; Constants
t         EQU 0x74                            ; Character 't'
h         EQU 0x68                            ; Character 'h'
e         EQU 0x65                            ; Character 'e'
spc       EQU 0x20                            ; Character space
null      EQU 0x0                             ; Null character

FIRST     DCB 0x20                            ; Define a space
STRING1   DCB "and the man said they must go" ; Original string
EoS       DCB 0x00                            ; End of string1
STRING2   SPACE 0x7F                          ; Allocate space for the final string

          END
