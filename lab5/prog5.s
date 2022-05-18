        .arch   armv8-a
        .data
        .align  2
f1:
        .float  0.3
f2:
        .float  0.59
f3:
        .float  0.11
        .text
        .align 2
        .global imageProcAsm
        .type   imageProcAsm, %function

// X0 <----- data
// X1 <----- newData
// W2 <----- x
// W3 <----- y

// S0 >----< sum of pixel
// S1 >----< buf
// S2 >----< multipled part
// X4 >----< iterator
// X5 >----< number of pixels
// X6 >----< buf
// S3 >----< f1
// S4 >----< f2
// S5 >----< f3



imageProcAsm:
        stp     d0, d1, [sp, #-16]!
        stp     d2, d3, [sp, #-16]!
        stp     d4, d5, [sp, #-16]!
        stp     d6, d7, [sp, #-16]!
        smull   x5, w2, w3
        mov     x6, #3
        mul     x5, x5, x6
        mov     x4, #0
        adr     x6, f1
        ldr     s3, [x6]
        adr     x6, f2
        ldr     s4, [x6]
        adr     x6, f3
        ldr     s5, [x6]
L1:
        movi    d0, #0x0
        cmp     x4, x5
        bge     L2
        ldrb    w6, [x0], #1
        ucvtf   s2, w6
//        adr     x6, f1
//        ldr     s1, [x6]
//        fmul    s2, s2, s1
        fmul    s2, s2, s3
//        fcvtzu  w6, s2
        fadd    s0, s0, s2
        ldrb    w6, [x0], #1
        ucvtf   s2, w6
//        adr     x6, f2
//        ldr     s1, [x6]
//        fmul    s2, s2, s1
        fmul    s2, s2, s4
//        fcvtzu  w6, s2
        fadd    s0, s0, s2
        ldrb    w6, [x0], #1
        ucvtf   s2, w6
//        adr     x6, f3
//        ldr     s1, [x6]
//        fmul    s2, s2, s1
        fmul    s2, s2, s5
//        fcvtzu  w6, s2
        fadd    s0, s0, s2
        fcvtzu  w6, s0
        strb    w6, [x1], #1
        add     x4, x4, #3
        b       L1
L2:
        ldp     d6, d7, [sp], #16
        ldp     d4, d5, [sp], #16
        ldp     d2, d3, [sp], #16
        ldp     d0, d1, [sp], #16
        ret
        .size   imageProcAsm, .-imageProcAsm

