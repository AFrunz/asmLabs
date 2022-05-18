	.arch armv8-a
	.data
lineNum:
	.byte	5
columNum:
	.byte 	3
	.align	2

//Store matrix in columns
matrix:
	.short	2, 5, 7, 9, 14
	.short	9, 12, 19, 0, 1
	.short	-2, 5, 12, 3, 8
	.align	3
ptrs:
	.skip	24
sums:
	.skip	24
buf:
	.skip	24
	.text
	.align 	2
	.global	_start
	.type	_start, %function
_start:
	adr	x0, lineNum
	ldrb	w1, [x0]
	adr	x0, columNum
	ldrb	w2, [x0]
	adr	x3, matrix
	adr	x4, sums
        ldr     x0, [sp]
calc:
//Calculating sum
        bl      calcSum
//Sort data
        bl      sort
_exit:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size	_start, .-_start


//Calculating sum
// w1 = lineN
// w2 = columnNum
// x3 = matrix
// x4 = summs
// x5 = i
// x6 = j
// x7 = sum
/// x8 = current
// x9 = buf
        .type   calcSum, %function
calcSum:
	mov	x5, #0
	mov	x8, x3
L1:
	cmp	x5, x2
	bge	L4
	mov	x6, #0
	mov	x7, #0
L2:
	cmp	x6, x1
	bge	L3
	ldrsh	w9, [x8, x6, lsl#1]
	sxth	x9, w9
	adds	x7, x7, x9
	bvs	_exit
	add	x6, x6, #1
	b	L2
L3:
	add     x8, x8, x1, lsl#1
	str	x7, [x4, x5, lsl#3]
	add	x5, x5, #1
	b	L1
L4:
        ret
        .size   calcSum, .-calcSum

//Sort
//x0 = flag ( 1 - up, 2 - down)
// w1 = lineN
// w2 = columnNum
// x3 = matrix
// x4 = summs
// x5 = min
// x6 = minIndex
// x7 = i
// x8 = j
// x9 = buf
        .type sort, %function
sort:
        stp     x29, x30, [sp, #-16]!
	mov	x5, #0
	mov	x6, #0
	mov	x7, #0
	mov	x8, #0
L5:
	cmp	x7, x2
	bge	L9
	ldr	x5, [x4, x7, lsl#3]
	mov	x6, x7
	mov	x8, x7
L6:
	cmp	x8, x2
	bge	L8
	ldr	x9, [x4, x8, lsl#3]
        cmp     x0, #1
        beq     cond0
cond1:
	cmp	x5, x9
	bge	L7
	mov	x5, x9
	mov	x6, x8
        b       L7
cond0:
	cmp	x5, x9
	ble	L7
	mov	x5, x9
	mov	x6, x8
L7:
	add	x8, x8, #1
	b	L6
// Exchange
L8:
	ldr	x9, [x4, x7, lsl#3]
	ldr	x5, [x4, x6, lsl#3]
	str	x5, [x4, x7, lsl#3]
	str	x9, [x4, x6, lsl#3]

// Push to the stack
        stp x5, x6, [sp, #-16]!
        stp x7, x8, [sp, #-16]!
        stp x9, x10, [sp, #-16]!
        stp x11, x12, [sp, #-16]!
        mov x5, x6
        mov x6, x7
	bl	colEx
// Pull from the stack
	ldp	x11, x12, [sp], #16
	ldp	x9, x10, [sp], #16
        ldp     x7, x8, [sp], #16
        ldp     x5, x6, [sp], #16
	add	x7, x7, #1
	b	L5
L9:
        ldp     x29, x30, [sp], #16
        ret
        .size   sort, .-sort

// Column exchange
	.type	colEx, %function
colEx:
        mul x7, x5, x1
        add x7, x3, x7, lsl#1
        mul x8, x6, x1
        add x8, x3, x8, lsl#1
        mov x9, #0
L10:
        cmp x9, x1
        bge L11
        ldrsh   w10, [x7, x9, lsl#1]
        ldrsh   w11, [x8, x9, lsl#1]
        strh    w10, [x8, x9, lsl#1]
        strh    w11, [x7, x9, lsl#1]
        add x9, x9, #1
        b   L10
L11:
        ret
        .size colEx, .-colEx








