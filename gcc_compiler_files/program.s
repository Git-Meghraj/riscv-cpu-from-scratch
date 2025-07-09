    .section .text
    .globl _start
_start:
    addi x14, x0, 15
    addi x11, x0, 1

loop_outermost:
    addi x10, x0, 1000
    addi x12, x0, 1000

loop_inner:
    addi x12, x12, -1
    beq  x12, x0, end_inner
    jal  x0, loop_inner

end_inner:
    addi x12, x0, 1000
    addi x10, x10, -1
    beq  x10, x0, end_outer
    jal  x0, loop_inner

end_outer:
    addi x10, x0, 1000
    addi x14, x14, -1
    beq  x14, x0, toggle
    jal  x0, loop_outermost

toggle:
    addi x11, x11, -1
    addi x14, x0, 15

    addi x10, x0, 1000
    addi x12, x0, 1000

loop_inner2:
    addi x12, x12, -1
    beq  x12, x0, end_inner2
    jal  x0, loop_inner2

end_inner2:
    addi x12, x0, 1000
    addi x10, x10, -1
    beq  x10, x0, end_outer2
    jal  x0, loop_inner2

end_outer2:
    addi x10, x0, 1000
    addi x14, x14, -1
    beq  x14, x0, _start
    jal  x0, loop_inner2
