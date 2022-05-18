	.arch armv8-a
	.file	"progs.c"
	.text
	.global	msg
	.data
	.align	3
	.type	msg, %object
	.size	msg, 18
msg:
	.string	"RESULT\nCLIB: %lf\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
	stp	x29, x30, [sp, -32]!
	add	x29, sp, 0
	fmov	s0, 5.0e-1
	str	s0, [x29, 28]
	ldr	s0, [x29, 28]
	fcvt	d0, s0
	bl	cos
	fcvt	s0, d0
	str	s0, [x29, 24]
	ldr	s0, [x29, 24]
	fcvt	d0, s0
	adrp	x0, msg
	add	x0, x0, :lo12:msg
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	ret
	.size	main, .-main
	.ident	"GCC: (Linaro GCC 7.5-2019.12) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
