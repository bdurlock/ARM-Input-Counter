/********************************************************************
Brett Durlock

The program classifies each character in an input stream, and then
produces a summary about that input stream by displaying the
total counts of multiple fields.

********************************************************************/

	.global main

	.text
main:	push	{lr}

	mov	r4, #0	@ Initialize character count
	mov	r5, #0	@ Newline Count
	mov	r6, #0	@ Whitespace Characters
	mov	r7, #0	@ Octal Digits
	mov	r8, #0	@ Decimal Digits
	mov	r9, #0	@ Hexidecimal Digits
	mov	r10, #0 @ Letters

loop:	bl	getchar	@ Read on character (returned in r0)

	cmp	r0, #-1	@ Compare return value to EOF
	beq	end	@ When EOF found, exit loop

	add	r4, r4, #1	@Incremenet character count

@ Find New Line Characters

if1:	cmp	r0, #0x0A	@ Compare return value to blank
	bne	then1

	add	r5, r5, #1	@Incremenet newline count
	add	r6, r6, #1	@Increment whitespace count

then1:

@ Find Whitespace Characters

if2:	cmp	r0, #0x20	@ Compare return value to space
	bne	then2

	add	r6, r6, #1	@ Increment whitespace count

then2:

if3:	cmp	r0, #0x09	@ Compare return value to tab
	bne	then3

	add	r6, r6, #1	@ Increment whitespace count

then3:

if4:	cmp	r0, #0x0B	@ Compare return value to vertical tab
	bne	then4

	add	r6, r6, #1	@ Increment whitespace count

then4:

@ Find Octal Digits

if5:	cmp	r0, #'0'
	blt	endif5
	cmp	r0, #'7'
	bgt	endif5
then5:
	add r7, r7, #1	@ Increment octal count

endif5:

@ Find Decimal Digits

if6:	cmp	r0, #'0'
	blt	endif6
	cmp	r0, #'9'
	bgt	endif6
then6:
	add r8, r8, #1	@ Increment decimal count
	add r9, r9, #1	@ While we're here, might as well count this for Hex
endif6:

@ Find Hexidecimal Digits (The rest of them)

if7:	cmp	r0, #0x41	@ less than A
	blt	endif7
	cmp	r0, #0x46	@ greater than F
	bgt	endif7
then7:
	add	r9, r9, #1	@ Increment Hex Count
endif7:

if8:	cmp	r0, #0x61	@ Less than a
	blt	endif8
	cmp	r0, #0x66	@ greater than f
	bgt	endif8
then8:
	add	r9, r9, #1	@ Increment Hex Count
endif8:

@Find Letters

if9:	cmp	r0, #0x41	@ less than A
	blt	endif9
	cmp	r0, #0x5A	@ greater than Z
	bgt	endif9
then9:
	add	r10, r10, #1	@ Increment Letter Count
endif9:

if10:	cmp	r0, #0x61	@ less than a
	blt	endif10
	cmp	r0, #0x7A	@ greater than z
	bgt	endif10
then10:
	add	r10, r10, #1	@ Increment Letter Count
endif10:

	b	loop		@ Loop back to the top, until we have gone through everything

@ Print Results

end:	ldr	r0, =fmt1	@ Print total characters
	mov	r1, r4
	bl	printf

	ldr	r0, =fmt2	@ Print Newline Characters
	mov	r1, r5
	bl	printf

	ldr	r0, =fmt3	@ Print Whitespace Characters
	mov	r1, r6
	bl	printf

	ldr	r0, =fmt4	@ Print Octal Digits
	mov	r1, r7
	bl	printf

	ldr	r0, =fmt5	@ Print Decimal Digits
	mov	r1, r8
	bl	printf

	ldr	r0, =fmt6	@ Print Hexidecimal Digits
	mov	r1, r9
	bl	printf

	ldr	r0, =fmt7	@ Print Letter Count
	mov	r1, r10
	bl	printf

	pop	{lr}
	bx	lr

fmt1:	.asciz	"\nTotal number of characters = %d\n"
fmt2:	.asciz	"\nNumber of newline characters = %d\n"
fmt3:	.asciz	"\nNumber of whitespace characters = %d\n"	@ blanks, tabs and newlines
fmt4:	.asciz	"\nNumber of octal digits = %d\n"	@ in the set 0-7
fmt5:	.asciz	"\nNumber of decimal digits = %d\n"	@ In the set 0-9
fmt6:	.asciz	"\nNumber of hexidecimal digits = %d\n"	@ In the set {0-9,A-F, a-f}
fmt7:	.asciz	"\nNumber of letters = %d\n"	@In the set {A-Z, a-z}
