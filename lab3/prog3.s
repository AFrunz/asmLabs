        .arch    armv8-a
        .data
        .align  3
standartFilename:
        .asciz  "/home/students/f/frunze.ad/assembler/prog3/myfile.txt"
error:
        .asciz  "Ops, invalid file name\n"
        .equ    er, .-error

        .text
        .align  2
        .global _start
        .type   _start, %function

//x5 = len
//x6 = carry
//x7 = f
//x8 = cond1
//x9 = cond2
_start:


        //open file
        ldr     x0, [sp]
        cmp     x0, #2
        blt     L12
        mov     x0, #-100
        mov     x3, #0600
        ldr     x1, [sp, #16]
        mov     x2, #0x241
        mov     x8, #56
        svc     #0
        cmp     x0, #0
        blt     L12
        mov     x7, x0
// Word reading
//
L1:
        bl      getWord
        mov     x6, x0
        mov     x5, x1
L2:
        cmp     x6, #2
        cset    x8, ne
        cmp     x5, #0
        cset    x9, ne
        orr     x8, x8, x9
        cbz     x8, L10
        mov     x0, sp
        mov     x1, x5
        stp     x4, x5, [sp, #-16]!
        bl      isPalindrome
        ldp     x4, x5, [sp], #16
        cmp     x0, #0
        beq     L1
        cmp     x6, #0
        bne     L3
        mov     x8, #32
        strb    w8, [sp, #-1]!
        b       L4
L3:
        mov     x8, '\n'
        strb    w8, [sp, #-1]!
L4:
//file print
        mov     x0, x7
        mov     x1, sp
        mov     x2, x5
        stp     x3, x4, [sp, #-16]!
        stp     x5, x6, [sp, #-16]!
        stp     x7, x8, [sp, #-16]!
        bl      filePrint
        ldp     x7, x8, [sp], #16
        ldp     x5, x6, [sp], #16
        ldp     x3, x4, [sp], #16
        add     sp, sp, x5
        b       L1
L10:
        mov     x0, x7
        mov     x8, #57
        svc     #0
L11:
//exit
        mov     x0, #0
        mov     x8, #93
        svc     #0
L12:
        mov     x0, #1
        adr     x1, error
        mov     x2, er
        mov     x8, #64
        svc     #0
        b       L11
        .size   _start, .-_start


//x0 = f
//x1 = wordPtr
//x2 = len.

        .type   filePrint, %function
filePrint:


        mov     x9, x2
        mov     x10, #0
        mov     x2, #1
        add     x1, x1, x9
       // mov     x0, #1
R1:
        str     x0, [sp, #-16]!
        cmp     x10, x9
        bgt     R4
        mov     x8, #64
        svc     #0
        ldr     x0, [sp], #16
        sub     x1, x1, #1
        add     x10, x10, #1
        b       R1
R4:
        ret
        .size   filePrint, .-filePrint


//x0 = strPtr
//x1 = len
//
//x2 = i
//x3 = len / 2
//x4 - cond1
//x5 - cond2

        .type   isPalindrome, %function
isPalindrome:
        mov     x2, #0
        mov     x4, #2
        cbz     x1, P3
        sdiv    x3, x1, x4
P1:
        cmp     x2, x3
        bge     P2
        ldrsb   w4, [x0, x2]
        sub     x5, x1, x2
        sub     x5, x5, #1
        ldrsb   w5, [x0, x5]
        cmp     w4, w5
        bne     P2
        add     x2, x2, #1
        b       P1
P2:
        cmp     x2, x3
        bne     P4
P3:
        mov     x0, #1
        ret
P4:
        mov     x0, #0
        ret
        .size   isPalindrome, .-isPalindrome

//x0 = carry --> x9
//x1 = len --> x10

//x11 = i
//x12 = flag
//x13 = cond1
//x14 = cond2
        .type   getWord, %function
getWord:
//init
        stp     x29, x30, [sp, #-16]!
        sub     sp, sp, #16
        mov     x29, sp
        mov     x9, #0
        mov     x11, #0
//getchar()
        mov     x0, #0
        mov     x1, x29
        mov     x2, #1
        mov     x8, #63
        svc     #0
        ldrb    w12, [x29]
//skip spaces
T1:
        cmp     w12, ' '
        cset    x13, eq
        cmp     w12, '\t'
        cset    x14, eq
        orr     x13, x13, x14
        cmp     x13, #1
        bne     T2

        mov     x0, #0
        mov     x1, x29
        mov     x2, #1
        mov     x8, #63
        svc     #0
        strb    w12, [x29]
        b       T1
T2:
//getWord
        cmp     w12, ' '
        cset    x13, ne
        cmp     w12, '\t'
        cset    x14, ne
        and     x13, x13, x14
        cmp     x13, #1
        bne     T7
        cmp     w12, '\n'
        beq     T3
        b       T4
T3:
        mov     x9, #1
        b       T7
T4:
        cmp     x0, #0
        beq     T5
        b       T6
T5:
        mov     x9, #2
        b       T7
T6:
        strb    w12, [sp, #-1]!
        mov     x0, #0
        mov     x1, x29
        mov     x2, #1
        mov     x8, #63
        svc     #0
        ldrb    w12, [x29]
        add     x11, x11, #1
        b       T2
T7:
        mov     x0, x9
        mov     x1, x11
        ldp     x29, x30, [x29, #16]
        ret
        .size   getWord, .-getWord








