        AREA RESET_HANDLER, CODE, READONLY
        CODE32
        ALIGN
        EXPORT  Reset_Handler

        IMPORT  |Image$$FIQ_STACK$$ZI$$Limit|
        IMPORT  |Image$$IRQ_STACK$$ZI$$Limit|
        IMPORT  |Image$$SYS_STACK$$ZI$$Limit|
        IMPORT  |Image$$SVC_STACK$$ZI$$Limit|
        IMPORT  __main

INT_OFF   EQU 0xC0
USER_MODE EQU 0x10
FIQ_MODE  EQU 0x11
IRQ_MODE  EQU 0x12
SVC_MODE  EQU 0x13
SYS_MODE  EQU 0x1F
        
Reset_Handler
        MRS r0, cpsr
        BIC r0, r0, #0xFF
        ORR r0, r0, #INT_OFF | FIQ_MODE
        MSR cpsr_c, r0
        MOV r8,  #0
        MOV r9,  #0
        MOV r10, #0
        MOV r11, #0
        MOV r12, #0
        LDR sp, =|Image$$FIQ_STACK$$ZI$$Limit|

        MSR cpsr_c, #INT_OFF | IRQ_MODE
        LDR sp, =|Image$$IRQ_STACK$$ZI$$Limit|
        
        MSR cpsr_c, #INT_OFF | SYS_MODE
        LDR sp, =|Image$$SYS_STACK$$ZI$$Limit|
        
        MSR cpsr_c, #INT_OFF | SVC_MODE
        LDR sp, =|Image$$SVC_STACK$$ZI$$Limit|
        
        MRC     p15, 0, r0, c1, c0, 0       ; read CP15 register 1 into r0
        LDR     r1, =0x100D                 ; b0=MMU, b2=dc, b3=wb, b12=ic: 0001_0000_0000_1101=0x100D
        MVN     r1, r1                      ; Invert bits in r1
        AND     r0, r0, r1
        MCR     p15, 0, r0, c1, c0, 0       ; Disable MMU/Protection unit, 

        MOV     r0, #0
        MCR     p15, 0, r0, c7, c7, 0       ; invalidate caches
        MCR     p15, 0, r0, c8, c7, 0       ; invalidate TLBs
        
        LDR     r1,=__main
        MOV     pc, r1

        END
