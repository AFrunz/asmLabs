	.arch armv8-a
	.data
	.align 	3
res:
	.skip	8
a:
	.word	-121
e:
	.word	-234
b:
	.short	0
c:
	.short	-23
d:
	.short	0

	.text
	.align 2
	.global _start
	.type _start, %function	
_start:	
	adr	x0, a
	ldrsw	x1, [x0]
	adr	x0, e
	ldrsw	x2, [x0]
	adr	x0, b
	ldrsh	w3, [x0]
	adr	x0, c
	ldrsh	w4, [x0]
	adr	x0, d
	ldrsh	w5, [x0]
	
	smull   x11, w5, w5
	smull   x12, w4, w4	
	sxtw    x3, w3
	msub    x12, x12, x3, x11
	//bEQ	exit
	cbz 	x12, exit

	add	w6, w4, w3
	add	x7, x1, x2
	sxtw	x6, w6
	mul	x8, x1, x6
	sxtw	x5, w5
	msub	x10, x7, x5, x8
	sdiv	x14, x10, x12
	adr	x0, res
	str	x14, [x0]
exit:
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size 	_start, .-_start
