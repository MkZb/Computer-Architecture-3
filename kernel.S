.syntax unified
.cpu cortex-m4
.thumb
#define A #1
#define B #2
#define C #3

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
	.word __stack_start 
	.word __kernel_reset__+1
	.size vtable_kernel, .-vtable_kernel

.section .rodata
	start: .asciz "kernel started!\n"
	finish: .asciz "Value in register #3: "

.section .text
__kernel_reset__:
	ldr r0, =start
	bl dbgput_line

// calculate 
	lab3:
    mov r0, A
    mov r1, B
    mov r2, C

	calc:
	    mov r3, #2 //divider
	    adds r0, r1
	    sdiv r0, r3

	//factorial calculation
	factorial:
	    mov r3, #1 //result
	    .factorial_loop:
	        mul r3, r2
	        subs r2, #1
	        bne .factorial_loop
	    mov r2, r3
	sum:
		adds r0, r2
		mov r3, r0

	ldr r0, =finish
	bl dbgput
	mov r0, r3
	bl dbgput_num
	
	end:
	b end