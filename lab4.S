.global lab4
.syntax unified

#define X1 #-9
#define X2 #10
#define X3 #31
#define X4 #-21

lab4:
	push {lr}
	bl task1
	bl task2
	pop {pc}

task1:
	push {lr}
	mov r0, X1
	mov r1, #0xFFFFFFFF

	mov r2, X2

	mov r4, X3

	mov r6, X4

	// Calculation: 8 * (X1 - X2) + (X3 ^ X4 - 1) / 16
	
	// X1 - X2
	sub r0, r2

	// 8 * (X1 - X2)
	mov r3, #3
mult_eight:
	mov r10, r0
	lsl r0, #1
	lsl r1, #1
	and r10, #0x80000000
	cmp r10, #0
	beq skip_over1
	add r1, #1
skip_over1:
	sub r3, #1
	cmp r3, #0
	bne mult_eight
	
	// X3 ^ X4
	eor r4, r6
	
	// X3 ^ X4 - 1
	sub r4, #1
	
	// (X3 ^ X4 - 1) / 16
	asr r4, #4

	// 8 * (X1 - X2) + (X3 ^ X4 - 1) / 16
	add r0, r4
	bvc skip_over2
	add r1, #1
skip_over2:
	bl result_correction
	pop {pc}
	
// Result correction
result_correction:
	push {lr}
	//step1
	bvc step2
	mov r10, #1
	and r10, r1
	lsr r1, #1
	orr r1, r1, #0x80000000
	lsr r0, #1
	cmp r10, #0
	beq step2
	orr r0, r0, #0x80000000 
step2:
	orr r0, r0, #0
	bne step4
	//step3
	mov r0, #8115
step4:
	mov r10, #8115
	add r1, r10
	//step 5
	and r5, r1, #0x80000000
	and r6, r1, #0x40000000
	lsl r6, #1
	cmp r5, r6
	beq step7
	//step6
	mov r10, #1
	and r10, r1
	lsr r1, #1
	orr r1, r1, r5
	lsr r0, #1
	cmp r10, #0
	beq step7
	orr r0, #0x80000000 
step7:
	bvs end_correction
	push {r0}
	push {r1}
	pop {r1}
	pop {r0}

end_correction:
	pop {pc}

task2:
	push {lr}

	mov r1, #25
	mov r2, #5

program_a:
	// 1: r0 = r1 - r2
	sub r0, r1, r2
	
	// 2: r0 = r1 * r2
	mul r0, r1, r2
	
jump3:
	// 3: r0 = r1 + r2
	add r0, r1, r2
	
	// 4: jump1
	bvs jump1
	
	// 6: r0 = r1 + r2
	add r0, r1, r2
	cmp r0, #0
	
	b jump2
jump1:
	bl program_b

	// 5: r0 = r0 + 10
	add r0, #10
	
	// 7: r1 = r1 - 3
	sub r1, #3
jump2:
	// 8: jump3
	beq jump3
	
	// 9: r0 = r0 & r1
	and r0, r1
	pop {pc}

program_b:
	push {lr}
jump5:
	// 10: r2 = r2 + 45
	add r2, #45
	
	// 11: jump4
	bcc jump4

	bl program_c

	// 12: r1 = r1 ^ r2 
	eor r1, r2
jump4:
	// 13: jump5
	// had to change from bvc to bvs because of endless cycle
	bvs jump5
	
	// 14: r0 = r1 + r2
	add r0, r1, r2
	
	// 15: r0 = r1 - r2
	sub r0, r1, r2
	
	pop {pc}

program_c:
	push {lr}
	
	// 17: r0 = r1 + r2
	adds r0, r1, r2
	
	// 18: r0 = r2 / r1
	udiv r0, r2, r1
	
	pop {pc}
