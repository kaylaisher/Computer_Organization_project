.data
    msg_dividend:   .asciiz "Enter Dividend: "
    msg_divisor:    .asciiz "Enter Divisor: "
    msg_quotient:   .asciiz "\nQuotient: "
    msg_remainder:  .asciiz "\nRemainder: "
    newline:        .asciiz "\n"

.text
.globl main

main:
    # --- Input Section ---
    
    # 1. Prompt and read Dividend
    li      $v0, 4
    la      $a0, msg_dividend
    syscall

    li      $v0, 5
    syscall
    move    $s0, $v0        # $s0 = Dividend

    # 2. Prompt and read Divisor
    li      $v0, 4
    la      $a0, msg_divisor
    syscall

    li      $v0, 5
    syscall
    move    $s1, $v0        # $s1 = Divisor

    # ======================================================
    #   PART 1: PRE-PROCESSING (Handle Signs)
    #   Goal: Convert inputs to positive, remember original signs
    #   TODO: fill this part below as an exercise
    #   (this part is no needed for unsigned version)
    # ======================================================






    # --- PART 1 end here ----------------------------------
    # ======================================================
    #   CORE ALGORITHM (Unsigned Restoring/Non_Restoring Divider)
    #   (NOTE:After PART 1 dividend and divisor are guaranteed to be unsigned.)
    # ======================================================

    # --- Initialization (Start) ---
    # The Remainder is a 64-bit value split into two registers:
    # $t1 = Remainder High (Left half) - Initialized to 0
    # $t0 = Remainder Low  (Right half) - Initialized to Dividend
    li      $t1, 0          # Remainder High (Hi) = 0
    move    $t0, $s0        # Remainder Low  (Lo) = Abs(Dividend)
    li      $t2, 0          # Loop counter (i = 0)

    # --- Step 1: Initial Shift Left ---
    # "Shift the Remainder register left 1 bit."
    # We must perform a 64-bit shift across $t1 and $t0.
    srl     $t3, $t0, 31    # 1. Get MSB of Low ($t0) into $t3
    sll     $t1, $t1, 1     # 2. Shift High ($t1) left by 1
    or      $t1, $t1, $t3   # 3. Move the MSB from Low into the LSB of High
    sll     $t0, $t0, 1     # 4. Shift Low ($t0) left by 1

    # ======================================================
    # Part 2. continue coding!!!
    #  TODO: complete the part below as an exercise, be creative
    # ======================================================


loop:
    sub $t1, $t1, $s1
    bltz $t1, is_negative
    srl  $t3, $t0, 31     
    sll  $t1, $t1, 1     
    or   $t1, $t1, $t3    
    sll  $t0, $t0, 1     
    ori $t0, $t0, 1
    j check_loop

is_negative:
    add $t1, $t1, $s1
    srl  $t3, $t0, 31     
    sll  $t1, $t1, 1      
    or   $t1, $t1, $t3    
    sll  $t0, $t0, 1     

check_loop:
    # --- Check Loop Condition ---
    # "32rd repetition?"
    addi    $t2, $t2, 1     # Increment counter
    bne     $t2, 32, loop   # If counter != 32, repeat loop 
    
    # --- Part 2 ends here ------------------------------------
    # =========================================================
    #  DEBUG: Print Remainder AFTER 32nd Loop (Before Correction)
    #  this block is RIGHT AFTER "bne $t2, 32, loop"
    #  Do not change anything here
    # =========================================================

    # 1. Save Registers
    # because syscall will change $v0 和 $a0，we have to protect the current computation result
    move    $t8, $a0        # save $a0
    move    $t9, $v0        # save $v0

    # 2. print the debug message
    .data
    msg_debug: .asciiz "\n[DEBUG] Loop 32 Remainder (Hi): "
    .text
    li      $v0, 4
    la      $a0, msg_debug
    syscall

    # 3. print Remainder High ($t1)
    move    $a0, $t1        # put remainder High into $a0 for printing
    li      $v0, 1          # print_int
    syscall

    # 4. print newline 
    li      $v0, 11         # print_char
    li      $a0, 10         # ASCII 10 = Newline
    syscall

    # 5. Restore Registers
    move    $a0, $t8        # restore $a0
    move    $v0, $t9        # restore $v0

    # =========================================================
    #  End of DEBUG Block -> Continue to Final Correction
    # =========================================================

    # =========================================================
    # Part3. Final Correction after 32 repitition 
    # TODO: fill the part below as an exercise
    # =========================================================
    srl $t1, $t1, 1



    #--- Part 3 ends here -------------------------------------
    # At this point:
    # $t0 = Absolute Quotient
    # $t1 = Absolute Remainder
    # =========================================================
    #   PART 4: POST-PROCESSING (Fix Signs)
    #   Goal: Restore signs based on the textbook(ppt) rules
    #   TODO: fill this part below as an exercise
    #   (this part is no needed for unsigned version)
    # =========================================================    









    #--- Part 4 ends here -------------------------------------
output_results:
    # Quotient is in $t0 (Low half)
    # Remainder is in $t1 (High half)

    # Print Quotient
    li      $v0, 4
    la      $a0, msg_quotient
    syscall

    move    $a0, $t0
    li      $v0, 1
    syscall

    # Print Remainder
    li      $v0, 4
    la      $a0, msg_remainder
    syscall

    move    $a0, $t1
    li      $v0, 1
    syscall

    # Exit program
    li      $v0, 10
    syscall
