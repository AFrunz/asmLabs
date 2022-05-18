        .arch   armv8-a
        .data

msg1:
        .string "Enter x and acurrancy\n"
msg2:
        .string "%lf %d"
msg3:
        .string "RESULT\nCLIB: %.15lf\nMY:   %.15lf\n"
msg4:
        .string "number: %d, value: %.15lf\n"
msg5:
        .string "accurancy index must be positive\n"
filename:
        .string "myfile.txt"
mode:
        .string "w"
        .align  3
defX:
        .double 0.3
defN:
        .word   32


        .text
        .align  2
        .global main
        .type   main, %function
main:
        stp     x29, x30, [sp, #-16]!
// get filename
        cmp     x0, #1
        beq     S3
        ldr     x1, [x1, #8]
        b       S4
S3:
        adr     x1, filename
S4:
// Entering x and accurance index
        mov     x6, x1
        adr     x0, msg1
        stp     x6, x7, [sp, #-16]!
        bl      printf
        adr     x0, msg2
        adr     x1, defX
        adr     x2, defN
        bl      scanf
        adr     x1, defX
        ldr     d0, [x1]
        adr     x0, defN
        ldr     w0, [x0]
        ldp     x6, x7, [sp], #16
        cmp     w0, #0
        ble     S1
//        adr     x0, defX
//        ldr     d0, [x0]
//        adr     x0, defN
//        ldr     x0, [x0]
        str     x0, [sp, #-8]!
        str     d0, [sp, #-8]!
        mov     x1, x6
        bl      customCos
        fmov    d1, d0
        ldr     d0, [sp], #8
        ldr     x0, [sp], #8
        stp     d1, d2, [sp, #-16]!
        bl      cos
        ldp     d1, d2, [sp], #16
        adr     x0, msg3
        bl      printf
        b       S2
S1:
        adr     x0, msg5
        bl      printf
S2:
        mov     x0, #0
        ldp     x29, x30, [sp], #16
        ret

        .size   main, .-main





// D0   <---- X
// X0   <---- num of accurancy
// X1   >----< FilenamePointer
// D16  >----< current member
// D17  >----< res
// X2   >----< int counter
// D18  >----< double num of accurancy
// D19  >----< accurancy
// X3   >----< factorial counter
// D20  >----< float counter
// D21  >----< buf
// X4   >----< file descriptor
        .global customCos
        .type   customCos, %function
customCos:
        stp     x29, x30, [sp, #-16]!
        fmov    d16, #1.
        fmov    d17, #1.
        mov     x2, #0
        scvtf   d18, x0
        fmov    d19, #1.
// file opening


        stp     x0, x2, [sp, #-16]!
        mov     x0, x1
        adr     x1, mode
        bl      fopen
        mov     x4, x0
        ldp     x0, x2, [sp], #16
// calc accurancy
L1:
        cmp     x2, x0
        bge     L2
        add     x2, x2, #1
        fmov    d21, #10.
        fdiv    d19, d19, d21
        b       L1
L2:
        mov     x2, #1
        mov     x3, #0
L3:
        fabs    d21, d16
        fcmp    d21, d19
        blt     L4
        fmul    d16, d16, d0
        fmul    d16, d16, d0
        add     x3,  x3, #1
        scvtf   d20, x3

        fdiv    d16, d16, d20
//        fadd    d20, d20, d21
//
//        stp     x0, x1, [sp, #-16]!
//        stp     x2, x3, [sp, #-16]!
//        stp     d0, d1, [sp, #-16]!
//        stp     d16, d17, [sp, #-16]!
//        stp     d18, d19, [sp, #-16]!
//        stp     d20, d21, [sp, #-16]!
//        adr     x0, msg4
//        mov     x1, #0
//        fmov    d0, d16
//        bl      printf
//        ldp     d20, d21, [sp], #16
//        ldp     d18, d19, [sp], #16
//        ldp     d16, d17, [sp], #16
//        ldp     d0, d1, [sp], #16
//        ldp     x2, x3, [sp], #16
//        ldp     x0, x1, [sp], #16
//
        fmov    d21, #1.
        fadd    d20, d20, d21
        fdiv    d16, d16, d20
        add     x3, x3, #1
        fneg    d16, d16
// file print
        stp     x0, x2, [sp, #-16]!
        stp     x3, x4, [sp, #-16]!
        stp     d0, d1, [sp, #-16]!
        stp     d16, d17, [sp, #-16]!
        stp     d18, d19, [sp, #-16]!
        stp     d20, d21, [sp, #-16]!
        mov     x0, x4
        mov     x3, x2
        adr     x2, msg4
        fmov    d0, d16
        bl      fprintf
        ldp     d20, d21, [sp], #16
        ldp     d18, d19, [sp], #16
        ldp     d16, d17, [sp], #16
        ldp     d0, d1, [sp], #16
        ldp     x3, x4, [sp], #16
        ldp     x0, x2, [sp], #16

        fadd    d17, d17, d16
        add     x2, x2, #1
        b       L3
L4:
        fmov    d0, d17
        mov     x0, x4
        bl      fclose
        ldp     x29, x30, [sp], #16
        ret
        .size   customCos, .-customCos

