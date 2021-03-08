.global lab1
.syntax unified

#define A #1
#define B #2
#define C #3

lab1:
    push {lr}
    // calculate
    mov r0, A
    mov r1, B
    mov r2, C
    bl calc
    pop {pc}

calc:
    push {r3, lr}
    mov r3, #2 //divider
    adds r0, r1
    sdiv r0, r3
    //factorial calculation
    bl factorial
    adds r0, r2
    pop {r3, pc}

factorial:
    push {lr}
    mov r3, #1 //result
    .factorial_loop:
        mul r3, r2
        subs r2, #1
        bne .factorial_loop
    mov r2, r3 
    pop {pc}
