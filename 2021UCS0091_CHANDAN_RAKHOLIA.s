.section .data
    @num1: .word  0B01111111111010111000000000000000, 0B01111111111000100100000000000000                                     
    @num1: .word 0x00220000, 0x00240000
    @num1: .word 0x001c0000, 0x00240000
    @num1: .word 0x00200000, 0x80010000
    @num1: .word 0x00240000, 0x001c0000
    @num1: .word 0xffe80000, 0x7fe00000
    @num1 : .word 0x7fe00000, 0xffe80000
    @num1 : .word 0x00260000, 0x00330000   @T1 0x0059A000 0x00368000
    num1 : .word 0x00260000, 0x80330000   @T2 0x8059A000 0x802F0000
    @num1 : .word 0x80260000, 0x00330000   @T3 0x8059A000 0x002F0000


    Addresult: .byte 0,0,0,0
    MultiplicationResult: .byte 0,0,0,0
.section .text
.global _start
    case_of_shiftby1:
        ldr r0, =0x0000007f
        and r5, r0, r7
        lsl r5, r5, #12
        lsr r6, r6, #20
        add r5, r5, r6
        mov r9, #1      @ store number of shift
        b next
    nfpmul:
        stmfd sp!, {r1-r9,lr}
        ldr r0, =num1
        ldr r1, [r0] @ r1 contains n1.
        add r0, r0, #4
        ldr r2, [r0] @ r2 contains n2.
        ldr r0, =0x0007ffff
        and r3, r1, r0 @3 contains mantisaa of n1 without shift 
        and r4, r2, r0 @r4 contains matissa of n2 without shift
        ldr r5, =0x00080000
        add r3,r3,r5  @r3 contains 1m of n1.
        add r4,r4,r5  @r4 contains 1m of n2.
        umull r6, r7, r3, r4 @ mul of m1 and m2 in R7R6.

        ldr r0, =0x00000080
        and r8, r7, r0
        cmp r8, #0
        bgt case_of_shiftby1

        else:
        ldr r0, =0x0000003f
        and r5, r0, r7
        lsl r5, r5, #13
        lsr r7, r7, #19
        add r5, r5, r7     @ r5 contain final mant. in 19 bits
        mov r9, #0
        @exponent
        next:
        ldr r0, =0x7ff80000
        and r3, r1, r0
        and r4, r2, r0
        lsl r3, #1
        lsr r3, #20
        lsl r4, #1
        lsr r4, #20
        add r6, r3, r4
        add r6, r6, r9
        lsl r6, r6, #20
        lsr r6, r6, #1      
        add r5, r5, r6       @ r5 contain final expo.
        @sign                    @ _expo+matissa
        ldr r0, =0x80000000
        and r3, r1, r0
        and r4, r2, r0
        eor r6, r3, r4
        add r5, r5, r6
        ldr r0, =[MultiplicationResult]
        add r0, r0, #4
        ldr r9, =0x0000ff
        and r8, r5, r9
        strb r8, [r0]

        ldr r9, =0x0000ff00
        and r8, r5, r9
        lsr r8, r8, #8
        sub r0, r0, #1
        strb r8, [r0]

        ldr r9, =0x00ff0000
        and r8, r5, r9
        lsr r8, r8, #16
        sub r0, r0, #1
        strb r8, [r0]

        ldr r9, =0xff000000
        and r8, r5, r9
        lsr r8, r8, #24
        sub r0, r0, #1
        strb r8, [r0]

        b add
        ldmfd sp!, {r1-r9,pc}
    swap:
        mov r0, r1
        mov r1, r2
        mov r2, r0
        mov r0, r3
        mov r3, r4
        mov r4, r0
        b next2
    mul_r8:
        mul r3, r3, r7
        b next3
    mul_r9:
        mul r6, r6, r7
        b next4
    nfpadd:
        @exponent
        ldr r0, =num1
        ldr r1, [r0]
        add r0, r0, #4
        ldr r2, [r0]
        ldr r0, =0x7ff80000
        and r3, r1, r0
        and r4, r2, r0
        cmp r3, r4    @R3 contains smaller exponent
        bgt swap      @R4 containes bigger exponent 
                      @R1 contains number with smaller expoent
        next2:        @R2 contains number with bigger exponent
        lsl r3, r3, #1
        lsl r4, r4, #1
        lsr r3, r3, #20
        lsr r4, r4, #20
        sub r0, r4, r3   @r0 contain difference of exponent
        
        @mantisaa        @R4 contains bigger exponent
        
        ldr r5, =0x0007ffff
        and r3, r1, r5     @r3 contains mantissa of number in r1
        and r6, r2, r5     @r6 contains mantissa of number in r2
        ldr r5, =0x00080000
        add r3, r3, r5    @r3 is 1m
        add r6, r6, r5    @r6 is 1m
        ldr r7, =0x80000000
        and r8, r1, r7
        and r9, r2, r7
        lsr r8, r8, #31
        lsr r9, r9, #31
        lsr r3, r3, r0
        mov r7, #-1
        cmp r8, #0
        bgt mul_r8
        next3:
        cmp r9, #0
        bgt mul_r9
        next4:
        add r7, r3, r6
        ldr r9, =0x80000000
        and r1, r7, r9    @  R1 contain sign bit  
        lsl r7, r7, #12 
        lsr r7, r7, #12 
        ldr r8, =0x00080000
        mov r0, #0
        findfirst1:
            and r9, r8, r7
            lsr r8, r8, #1
            add r0, #1
            cmp r9, #0
            beq findfirst1
        mov r8, r0
        lsl r7, r7, #12
        lsl r7, r7, r0
        lsr r7, r7, #13   @Renormalization Done
        sub r4, r4, r0
        add r4, r4, #1
        lsl r4, r4, #20
        lsr r4, r4, #1
        add r7, r7, r4   @R7 contains mantissa + exponent
        @sign
        add r7, r7, r1
        mov r5, r7
        ldr r0, =[Addresult]
        add r0, r0, #4
        ldr r9, =0x0000ff
        and r8, r5, r9
        strb r8, [r0]

        ldr r9, =0x0000ff00
        and r8, r5, r9
        lsr r8, r8, #8
        sub r0, r0, #1
        strb r8, [r0]

        ldr r9, =0x00ff0000
        and r8, r5, r9
        lsr r8, r8, #16
        sub r0, r0, #1
        strb r8, [r0]

        ldr r9, =0xff000000
        and r8, r5, r9
        lsr r8, r8, #24
        sub r0, r0, #1
        strb r8, [r0]
        b end;

_start:
    bl nfpmul
    add:
    bl nfpadd
    end:
        @ Given Task Done